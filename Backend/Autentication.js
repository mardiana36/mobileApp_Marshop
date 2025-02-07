const nodemailer = require('nodemailer');

const transport = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 587, 
    secure: false,  
    auth: {
        user: 'marshop3636@gmail.com',
        pass: 'qjlpeaptijvwthvw', 
    },
});

const sendVerificationEmail = (email, token) => {

    const mailOption = {
      from: 'Marshop <marshop3636@gmail.com>',
      to: email,  
      subject: 'Verify Your Account',
      html: `<p>Click this button to verify your account:</p>
             <a style="display: inline-block; padding: 10px 30px; text-decoration: none; color: #ffffff; font-weight: bold; background-color: #390099; border-radius:5px; font-size: 20px" href="http://192.168.18.155:3100/register/${token}">Verify Account</a>`,
    };
    

    transport.sendMail(mailOption, (error, info) => {
        if (error) {
            console.error("Gagal mengirim email:", error);
        } else {
            console.log("Email verifikasi terkirim:", info.response);
        }
    });
};

module.exports = sendVerificationEmail;
