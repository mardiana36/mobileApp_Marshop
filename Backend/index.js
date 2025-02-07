require("dotenv").config();
const express = require("express");
const { createPool } = require("mysql2/promise");
const { Snap } = require("midtrans-client");
const { hash, compare } = require("bcryptjs");
const { sign, verify } = require("jsonwebtoken");
const sendVerificationEmail = require("./Autentication");
const cors = require("cors");

const app = express();
const port = 3100;
app.use(cors());
app.use(express.json());

const secretKeyAut = process.env.MARSHOP_SECRET_KEY_AUTENTICATION;

const db = createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "marshop",
});

const snap = new Snap({
  isProduction: false,
  serverKey: process.env.MIDTRANS_SERVER_KEY,
});

app.post("/register/check", async (req, res) => {
  try {
    const key = Object.keys(req.body);
    const column = key[0];
    const value = req.body[column];
    const sql = `SELECT ${column} FROM user WHERE ${column} = ?`;
    const [result] = await db.execute(sql, [value]);
    if (result.length > 0) {
      res
        .status(200)
        .json({ data: `${column} already registered. Use another!` });
    } else {
      res.status(201).json({ data: `${column} is available.` });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal server error." });
  }
});

app.post("/register", async (req, res) => {
  try {
    const { phone, username, email, password } = req.body;
    const hashPassword = await hash(password, 10);
    const verificationToken = sign({ email }, secretKeyAut);

    const sql = `INSERT INTO user (username, email, password, verified, phone) VALUES(?,?,?,?,?)`;
    const [result] = await db.execute(sql, [
      username,
      email,
      hashPassword,
      false,
      phone,
    ]);

    if (result.affectedRows > 0) {
      sendVerificationEmail(email, verificationToken);
      res.status(200).json({
        data: "Registration successful, check email for verification!",
      });
    }
  } catch (error) {
    if (error.code === "ER_DUP_ENTRY") {
      if (error.message.includes("username")) {
        return res.status(202).json({ data: "Username already taken!" });
      } else if (error.message.includes("email")) {
        return res.status(202).json({ data: "Email already registered!" });
      } else if (error.message.includes("phone")) {
        return res
          .status(202)
          .json({ data: "Phone number already registered!" });
      }
    }
    console.error(error);
    res.status(204).json({ data: "Server error" });
  }
});

app.get("/register/:token", async (req, res) => {
  const token = req.params.token;
  try {
    const decoded = verify(token, secretKeyAut);
    const sql = `UPDATE user SET verified = ? WHERE email = ?`;
    const [result] = await db.execute(sql, [true, decoded.email]);
    if (result.affectedRows > 0) {
      res.status(200).send("Email verified successfully! Please log in.");
    } else {
      console.log(result);
    }
  } catch (error) {
    console.log(error);
  }
});

app.post("/login", async (req, res) => {
  try {
    const { identify, password } = req.body;
    const sql = `SELECT * FROM user WHERE username = ? OR email = ? OR phone = ?`;
    const [result] = await db.execute(sql, [identify, identify, identify]);
    if (result.length > 0) {
      const user = result[0];
      const isMatch = await compare(password, user.password);
      if (!isMatch) {
        return res.status(202).json({ data: "Incorrect password!" });
      }
      if (!user.verified) {
        return res.status(202).json({ data: "Email not verified!" });
      }
      const token = sign({ id: user.user_id, email: user.email }, secretKeyAut);
      res.status(200).json({
        data: "Login successful",
        user: {
          id: user.user_id,
          email: user.email,
          username: user.username,
          address: user.address,
          fullname: user.fullname,
          phone: user.phone,
          status: user.status,
          birth: user.birth,
          pathFoto: user.pathFoto,
          token: token,
        },
      });
    } else {
      res.status(202).json({ data: "Wrong phone/email/username!" });
    }
  } catch (error) {
    console.error(error);
    res.status(204).json({ data: "An error occurred. Please try again." });
  }
});

app.put("/profile/:id", async (req, res) => {
  try {
    const update = req.body;
    const id = req.params.id;
    const validKeys = Object.keys(update).filter((key) => update[key] !== "");
    const totalValidKeys = validKeys.length;
    if (totalValidKeys === 0) {
      return res.status(201).json({ data: "No changes detected." });
    }
    let sql = "UPDATE user SET ";
    let values = [];

    validKeys.forEach((key, index) => {
      sql += `${key} = ?`;
      if (index < totalValidKeys - 1) {
        sql += ", ";
      }
      values.push(update[key]);
    });
    sql += " WHERE user_id = ?";
    values.push(id);

    const [result] = await db.execute(sql, values);
    if (result.affectedRows > 0) {
      res.status(200).json({ data: "Profile Update Successful." });
    } else {
      res.status(201).json({ data: "No changes detected." });
    }
  } catch (error) {
    console.error("Error:", error);
    if (error.code === "ER_DUP_ENTRY") {
      if (error.message.includes("email")) {
        return res.status(202).json({ data: "Email already registered!" });
      } else if (error.message.includes("phone")) {
        return res
          .status(202)
          .json({ data: "Phone number already registered!" });
      }
    } else {
      res.status(204).json({ data: "Internal Server Error" });
    }
  }
});

app.get("/profile/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const sql = `SELECT * FROM user WHERE user_id = ?`;
    const [result] = await db.execute(sql, [id]);
    if (result.length > 0) {
      const user = result[0];
      const birthDate = new Date(user.birth);
      birthDate.setDate(birthDate.getDate() + 1);
      const formattedBirth =
        user.birth != null ? birthDate.toISOString().split("T")[0] : null;
      res.status(200).json({
        data: {
          email: user.email,
          address: user.address,
          fullname: user.fullname,
          pathFoto: user.pathFoto,
          gender: user.gender,
          birth: formattedBirth,
          phone: user.phone,
        },
      });
    } else {
      res.status(204).json({ data: "Filed to fetch data!" });
    }
  } catch (error) {
    console.error("Error:", error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});
// membuat toko
app.put("/shop", async (req, res) => {
  try {
    const { id } = req.body;
    const status = "seller";
    const sql = `UPDATE user SET status = ? WHERE user_id = ?`;
    const [result] = await db.execute(sql, [status, id]);
    if (result.affectedRows > 0) {
      res.status(200).json({
        data: "Congratulations, you have successfully registered your shop",
      });
    } else {
      res.status(202).json({
        data: "Sorry, an error occurred while registering your shop!",
      });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});

// update produk di toko
app.put("/shop/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const { name, description, price, stock, category_idFK, image_url } =
      req.body;
    const sql = `UPDATE products SET name = ?, description = ?, price = ?, stock = ?, category_idFK = ?, image_url = ? WHERE product_id = ?`;
    const [result] = await db.execute(sql, [
      name,
      description,
      price,
      stock,
      category_idFK,
      image_url,
      id,
    ]);
    if (result.affectedRows > 0) {
      res.status(200).json({ data: "Product data updated successfully" });
    } else {
      res
        .status(202)
        .json({ data: "An error occurred while updating product data!" });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});
//  ambil prodak toko berdasarkan yang login
app.get("/shop", async (req, res) => {
  try {
    const { id } = req.body;
    const sql = `SELECT * FROM products WHERE user_idFk = ?`;
    const [result] = await db.execute(sql, [id]);
    if (result.length > 0) {
      res.status(200).json({ data: result[0] });
    } else {
      res.status(204).json({ data: "Filed to fetch data!" });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});
// ambil data produk dan tampilkan data produk berdasarkan data produk yang di pilih di toko
app.get("/shop/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const sql = `SELECT * FROM products WHERE product_id = ?`;
    const sql2 = `SELECT * FROM categories`;
    const [result] = await db.execute(sql, [id]);
    const [result2] = await db.execute(sql2);
    if (result.length > 0 && result2.length > 0) {
      res.status(200).json({ data: result[0], category: result2 });
    } else {
      res.status(204).json({ data: "Filed to fetch data!" });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});
// hapus data produk di toko
app.delete("/shop", async (req, res) => {
  try {
    const { ids } = req.body;
    const placeholders = ids.map(() => "?").join(",");
    const sql = `DELETE FROM products WHERE id IN (${placeholders})`;
    const [result] = await db.execute(sql, ids);
    if (result) {
      res.status(200).json({ data: "Product deleted successfully" });
    } else {
      res.status(202).json({ data: "No matching product found" });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});

// ambil semua produk
app.get("/otherProdact/:id", async(req, res) => {
  try {
    const id = req.params.id;
    const sql = `SELECT p.*, u.address, u.user_id FROM products AS p INNER JOIN user AS u on u.user_id = p.user_idFk WHERE p.product_id != ?`;
    const [result] = await db.execute(sql, [id]);
    if (result.length>0) {
      res.json({ data: result });
    } else {
      console.log('Filead to fetch data !');
    }
  } catch (error) {
    console.log(error);
  }
})
app.get("/", async (req, res) => {
  try {
    const sql = `SELECT p.*, u.address, u.user_id FROM products AS p INNER JOIN user AS u on u.user_id = p.user_idFk`;
    const [result] = await db.execute(sql);
    if (result.length > 0) {
      res.status(200).json({ data: result });
    } else {
      res.status(204).json({ data: "Filed to fetch data!" });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});
app.get("/newProducts", async (req, res) => {
  try {
    const sql = `SELECT * FROM products ORDER BY created_at DESC LIMIT 5`;
    const [result] = await db.execute(sql);
    if (result.length > 0) {
      res.status(200).json({ data: result });
    } else {
      res.status(204).json({ data: "Filed to fetch data!" });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});

// ambil 1  produk
app.get("/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const sql = `SELECT p.*, u.user_id, u.Username, u.address, u.pathFoto FROM products AS p INNER JOIN user AS u on p.user_idFk = u.user_id WHERE p.product_id = ?`;
    const [result] = await db.execute(sql, [id]);
    if (result.length > 0) {
      res.status(200).json({ data: result[0] });
    } else {
      res.status(204).json({ data: "Filed to fetch data!" });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});

// ambil data keranjang berdasarkan yang login
app.get("/cart/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const sql = `SELECT c.cart_id, u.user_id, u.username, p.* FROM cart AS c INNER JOIN products AS p ON c.product_idFk = p.product_id INNER JOIN user AS u ON p.user_idFk = u.user_id WHERE c.user_idFk = ?`;
    const [result] = await db.execute(sql, [id]);
    if (result.length > 0) {
      res.status(200).json({ data: result });
      console.log(id);
    } else {
      res.status(204).json({ data: "Filed to fetch data!" });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});

app.get("/countCart/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const sql = `SELECT COUNT(*) AS total FROM cart WHERE user_idFk = ?;`;
    const [result] = await db.execute(sql, [id]);

    if (result && result[0] && result[0].total !== undefined) {
      res.status(200).json({ data: result[0] });
      console.log(result[0]);
    } else {
      res.status(204).json({ data: "No data found!" });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({ data: "Internal Server Error!" });
  }
});

// tambah  product ke keranjang
app.post("/cart", async (req, res) => {
  try {
    const { idU, idP } = req.body;
    const sql = `INSERT INTO cart (user_idFk, product_idFk) VALUES (?,?)`;
    const [result] = await db.execute(sql, [idU, idP]);
    if (result.affectedRows > 0) {
      res.status(200).json({ data: "Add to Cart successfully" });
      console.log("Create data successfully");
    } else {
      res.status(204).json({ data: "Filed Add to Cart!" });
      console.log("Filed to create data!");
    }
  } catch (error) {
    console.log(error);
  }
});

// update qty di keranjang berdasarkan id

//  hapus data cart
app.delete("/cart", async (req, res) => {
  try {
    const { ids } = req.body;
    const placeholders = ids.map(() => "?").join(",");
    const sql = `DELETE FROM cart WHERE cart_id IN (${placeholders})`;
    const [result] = await db.execute(sql, ids);
    if (result.affectedRows > 0) {
      res.status(200).json({ data: "Product deleted successfully" });
    } else {
      res.status(204).json({ data: "No matching product found" });
    }
  } catch (error) {
    console.log(error);
    res.status(204).json({ data: "Internal Server Error!" });
  }
});

app.post("/snap", async (req, res) => {
  try {
    const {
      orderId,
      grossAmount,
      firstName,
      lastName,
      email,
      phone,
      item_details,
    } = req.body;
    let parameter = {
      transaction_details: {
        order_id: orderId,
        gross_amount: grossAmount,
      },
      credit_card: {
        secure: true,
      },
      item_details: item_details.map((item) => ({
        id: item.id,
        price: item.price,
        quantity: item.quantity,
        name: item.name,
      })),
      customer_details: {
        first_name: firstName,
        last_name: lastName,
        email: email,
        phone: phone,
      },
      billing_address: {
        first_name: firstName,
        last_name: lastName,
        email: email,
        phone: phone,
      },
      shipping_address: {
        first_name: "Budi",
        last_name: "Susanto",
        email: "budisusanto@example.com",
        phone: "0812345678910",
        address: "Sudirman",
        city: "Jakarta",
        postal_code: "12190",
        country_code: "IDN",
      },
    };
    const transaction = await snap.createTransaction(parameter);
    res.json({ data: transaction });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: "Internal Server Erorr!" });
  }
});

app.post("/order", async (req, res) => {
  try {
    const { order_id, idU, totalPrice, orderUrl, items } = req.body;
    const sql = `INSERT INTO orders(order_id,user_idFk,total_price,orderUrl) VALUES(?,?,?,?)`;
    const sql2 = `INSERT INTO order_items(order_idFk,product_idFk,quantity,price) VALUES(?,?,?,?)`;
    const [result] = await db.execute(sql, [
      order_id,
      idU,
      totalPrice,
      orderUrl,
    ]);
    if (result.affectedRows > 0) {
      for (const item of items) {
        if (item.id != "D01") {
          await db.execute(sql2, [
            order_id,
            item.id,
            item.quantity,
            item.price,
          ]);
        }
      }
      res.json({ data: "Insert data Successfully!" });
    } else {
      res.json({ data: "Filed insert data!" });
    }
  } catch (error) {
    console.log(error);
  }
});

app.post("/Order", async (req, res) => {
  try {
    const { id } = req.params.id;
    const sql = `SELECT orders.*,products.*,orD.*,products.price AS priceP FROM order_items AS orD INNER JOIN orders ON orD.order_idFk = orders.order_id INNER JOIN products ON orD.product_idFk = products.product_id WHERE orders.user_idFk = ?`;
    const [result] = await db.execute(sql, [id]);
    if (result.affectedRows > 0) {
      res.json({ data: "Update data Successfully!" });
    } else {
      res.json({ data: "Filed update data!" });
    }
  } catch (error) {
    console.log(error);
  }
});
app.listen(port, () => {
  console.log("Server Running on: http://localhost:" + port);
});
