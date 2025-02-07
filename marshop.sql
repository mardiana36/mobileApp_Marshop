-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 20 Jan 2025 pada 11.56
-- Versi server: 10.4.27-MariaDB
-- Versi PHP: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `marshop`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `user_idFk` int(11) NOT NULL,
  `product_idFk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `cart`
--

INSERT INTO `cart` (`cart_id`, `user_idFk`, `product_idFk`) VALUES
(37, 40, 34),
(38, 40, 34);

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(1, 'Electronics'),
(2, 'Fashion'),
(3, 'Home & Kitchen'),
(4, 'Beauty & Personal Care'),
(5, 'Health & Fitness'),
(6, 'Toys & Games'),
(7, 'Books'),
(8, 'Sports & Outdoors'),
(9, 'Baby Products'),
(10, 'Groceries');

-- --------------------------------------------------------

--
-- Struktur dari tabel `orders`
--

CREATE TABLE `orders` (
  `order_id` varchar(255) NOT NULL,
  `user_idFk` int(11) NOT NULL,
  `total_price` decimal(10,0) NOT NULL,
  `orderUrl` text NOT NULL,
  `status` enum('pending','paid','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `orders`
--

INSERT INTO `orders` (`order_id`, `user_idFk`, `total_price`, `orderUrl`, `status`, `created_at`) VALUES
('ORDER-1737271982186', 40, '760000', 'https://app.sandbox.midtrans.com/snap/v4/redirection/e7421431-b4a6-40bd-9386-da47477a8681', 'pending', '2025-01-19 07:33:03'),
('ORDER-1737272085219', 40, '685000', 'https://app.sandbox.midtrans.com/snap/v4/redirection/d53e0a0a-882a-4a81-9373-e4091c3c99f3', 'pending', '2025-01-19 07:34:46'),
('ORDER-1737272987550', 40, '9500000', 'https://app.sandbox.midtrans.com/snap/v4/redirection/ee37018b-9f00-4c9b-9cbe-5726e7c04736', 'pending', '2025-01-19 07:49:49');

-- --------------------------------------------------------

--
-- Struktur dari tabel `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_idFk` varchar(255) NOT NULL,
  `product_idFk` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `order_items`
--

INSERT INTO `order_items` (`id`, `order_idFk`, `product_idFk`, `quantity`, `price`) VALUES
(24, 'ORDER-1737271982186', 39, 2, '400000.00'),
(25, 'ORDER-1737272085219', 39, 1, '400000.00'),
(26, 'ORDER-1737272085219', 35, 2, '150000.00'),
(27, 'ORDER-1737272987550', 34, 2, '5000000.00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `user_idFk` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,0) NOT NULL,
  `stock` int(11) NOT NULL,
  `sold` int(11) NOT NULL,
  `rating` decimal(10,1) NOT NULL DEFAULT 5.0,
  `category_idFk` int(11) NOT NULL,
  `image_url` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `products`
--

INSERT INTO `products` (`product_id`, `user_idFk`, `name`, `description`, `price`, `stock`, `sold`, `rating`, `category_idFk`, `image_url`, `created_at`) VALUES
(34, 33, 'Tracfone | Motorola Moto g Play 2024', '6.5\" HD+ 90Hz Display with Corning Gorilla Glass 3. / Snapdragon 680 processor.\r\n50MP sensor with Quad Pixel Photo Night Vision. / Dolby Atmos and Hi-Res Audio.\r\n5,000mAh battery for up to 46 hours of battery life. / 64GB of storage + 1TB more with microSD card. / 4GB RAM, expandable up to 6GB with RAM Boost.\r\nCarrier: This phone is locked to Tracfone, which means this device can only be used on the Tracfone wireless network. A Tracfone plan is required to activate this device. Activating is easy, upon receipt go to Tracfone Website and select “Activate” and follow the prompts.\r\nCompatible with our no-contract Unlimited Talk & Text plus Data plans starting as low as $20/month plus taxes and fees. To find the Tracfone Plans available to purchase, please go to our TF - Amazon Brand Page linked below the product title.', '5000000', 100, 50, '4.5', 1, 'aa1.jpg,aa2.jpg,aa3.jpg', '2025-01-18 14:24:26'),
(35, 33, 'AUTOMET  Oversized Leather Jackets Faux', 'Fabric:68% Polyurethane+27% Polyester+5% Cotton,High quality faux Leather\r\nDesign:Oversized,Plus Sized,Long Sleeve,Faux Leather Jackets,Zip Up Motorcycle Jacket,Fall Outfits,Y2k Fashion,Trendy Clothes,Punk Coat,Moto Biker Outwear,Bomber jacket women.\r\nMatch:This Jacket is suit for spring, autumn and winter. Just wear a basic T-shirt with jeans for a casual look or wear a dress shirt under it for formal occasions. This all-match style leather jacket must be an indispensable outerwear in your wardrobe.\r\nNEVER OUT OF FASHION：Professional cut,brilliant design, and premium stitching throughout. Stand collar with a button looks cool and cute. The zipper on the chest and waist zips smoothly and two side pockets brings a little special to this leather jacket.Basic but stylish, slim fit design style can show your figure better\r\nOccasion：This oversized leather jackets is suit for daily life,going out,dating,club,party,travel and you can match anything you like to get a fashion looks at fall,winter and spring.', '150000', 200, 120, '4.0', 2, 'b1.jpg,b2.jpg,b3.jpg', '2025-01-18 14:24:26'),
(36, 34, 'Coffee Maker', 'STRONG BREW: Increases the strength and bold taste of your coffee’s flavor.\r\n3 CUP SIZES: Brew an 8, 10, or 12 oz. cup at the push of a button.\r\nMULTIPLE CUP WATER RESERVOIR: 42oz. removable reservoir lets you brew up to 4 cups before refilling. 8 oz. cup size\r\nFAST & FRESH BREWED: Delicious coffee made in minutes.\r\nTRAVEL MUG FRIENDLY: Removable drip tray accommodates travel mugs up to 7.4” tall.\r\nENERGY EFFICIENT: Auto off feature turns off your coffee maker 5 minutes after the last brew, helping to save energy.\r\nCOMPATIBLE WITH THE MY K-CUP UNIVERSAL REUSABLE COFFEE FILTER: Brew your own ground coffee (sold separately).', '500000', 50, 30, '4.7', 3, 'c1.jpg,c2.jpg', '2025-01-18 14:24:26'),
(37, 35, 'Makeup Kit Makeup Sets for Teens', '【All In One Makeup Kit】The makeup kit Gift Set including 18 color eyeshadow palette,foundation,Concealer,Mascara,Lip Gloss,Eyebrow Pencil,Eyeliner,Contour Stick,Powder Puff,Makeup Brushes,Loose Powder,Concealer palette\r\n【Makeup Kit Gifts for Ladies】This professional makeup artist kit is sleek and neat containing everything you need to make a full face look. It is a perfect gift for yourself or your friends, sisters, young girls like teen daughters or niece for Birthday, Valentine\'s Day, Christmas and other Festivals\r\n【High Quality Make Up Kit】Cosmetics with pigmented formula are really vibrant and blend well.The Face powder, blush, Lipgloss, eyeshadow are skin-friendly, easy to apply & wash off. There is little fallout and not tested on animals\r\n【Wide Applications】Suitable for different occasions, like casual, salon, party, festival, wedding etc. Its versatile design and multiple colors make it an ideal gift for both makeup professionals and beauty beginners. make up kit for women full kit\r\n【Professionals Beginners Makeup Kit】This makeup set for women contains a complete range of cosmetics, suitable for different occasions makeup kits for teens makeup set for women make up kits for teenager make up set', '470000', 70, 40, '4.6', 4, 'd1.jpg,d2.jpg,d3.jpg,d4.jpg,d5.jpg', '2025-01-18 14:24:26'),
(38, 36, 'Fitbit Charge 6 Fitness Tracker with Google apps', 'Turn little habits into healthier routines with Fitbit Charge 6 and Google Pixel Buds Pro 2; get advanced health and fitness insights from Fitbit and power through your workouts with the most comfortable, secure earbuds\r\nPixel Buds Pro 2 and Fitbit Charge 6 cannot be connected to each other, but both are compatible with iOS and Android devices\r\nPixel Buds Pro 2 are small, light, and made to stay put; use the twist-to-adjust stabilizer to lock your earbuds in during workouts, or adjust the other way for all-day comfort\r\nMade to keep up with you, Pixel Buds Pro 2 have up to 30 hours of listening time with ANC[1]; wireless charging helps keep your battery full, almost anywhere and anytime, and they’re IPX4 water resistant[2]\r\nThe first Google Tensor chip in an earbud, the Tensor A1 chip powers twice the Active Noise Cancellation and delivers premium sound on Pixel Buds Pro 2[3]\r\nFitbit Charge 6 tracks key metrics from calories and Active Zone Minutes to Daily Readiness and sleep[4]; move more with 40+ exercise modes, built-in GPS, all-day activity tracking, 24/7 heart rate, automatic exercising tracking, and more\r\nSee your heart rate in real time when you link your Charge 6 to compatible exercise machines, like treadmills, ellipticals, and more[5]; and stay connected with YouTube Music controls[6]\r\nExplore advanced health insights with Fitbit Charge 6; track your response to stress with a stress management score; learn about the quality of your sleep with a personalized nightly Sleep Score; and wake up more naturally with the Smart Wake alarm\r\nFind your way seamlessly during runs or rides with turn-by-turn directions from Google Maps on Fitbit Charge 6[7,8]; and when you need a snack break on the go, just tap to pay with Google Wallet[8,9]\r\nPlease refer to the “Legal” section below for all applicable legal disclaimers denoted by the bracketed numbers in the preceding bullet points (e.g., [1], [2], etc', '1200000', 150, 90, '4.3', 5, 'e1.jpg,e2.jpg', '2025-01-18 14:24:26'),
(39, 34, 'GILOBABY Robot Toys', 'Unique Design: The robot toy is design in 2 part. The upper part is a cute robot with LED eyes and flexible arms, which can make different postures. The bottom part is tank tracks, which can slide left and right and rotate 360° in place\r\nEasy to Operate: With 6 wheels, equipped with 2.4 GHz remote controller, the remote control robot can move and dance under the control of the child, ideal for child\'s entry-level remote control toys, one-click demonstration of automatic dancing will provide hours of fun to children\r\nSkills Development: The RC robot toy will spark hours for kids of imagination in play, developing hand-eye coordination, motor skills, color Identification and creativity, which is very helpful for their intelligence and self-confidence\r\nGift Ideas: If you\'re looking for an ideal and exciting gift for birthday, Christmas or festival, then you\'ll love our RC robots for kids. Playing with family and friends is always exciting and everyone allows joining in the fun with GILOBABY\r\nChild Safety & Quality Assured: Made of child-friendly ABS material, BPA free, durable and smooth edge without burrs to protect children\'s hands', '400000', 200, 180, '4.2', 6, 'a1.jpg,a2.jpg,a3.jpg,a4.jpg,a5.jpg', '2025-01-18 14:24:26'),
(40, 33, 'A Novel Kindle', '#1 NEW YORK TIMES BESTSELLER • From the acclaimed author of The Longest Ride and The Notebook comes an emotional, powerful novel about wondering if we can change—or even make our peace with—the path we’ve taken.\r\n\r\n“Sparks is superb at what he does. The setting is postcard perfect. The characters are immensely likable. . . . This is a tidy miracle you can count on.”—The Washington Post\r\n\r\nTanner Hughes was raised by his grandparents, following in his grandfather’s military footsteps to become an Army Ranger. His whole life has been spent abroad, and he is the proverbial rolling stone: happiest when off on his next adventure, zero desire to settle down.  But when his grandmother passes away, her last words to him are find where you belong. She also drops a bombshell, telling him the name of the father he never knew—and where to find him.\r\n\r\nTanner is due at his next posting soon, but his curiosity is piqued, and he sets out for Asheboro, North Carolina, to ask around. He’s been in town less than twenty-four hours when he meets Kaitlyn Cooper, a doctor and single mom. They both feel an immediate connection; Tanner knows Kaitlyn has a story to tell, and he wants to hear it. To Kaitlyn, Tanner is mysterious, exciting—and possibly leaving in just a few weeks.\r\n\r\nMeanwhile, nearby, eighty-three-year-old Jasper lives alone in a cabin bordering a national forest. With only his old dog, Arlo, for company, he lives quietly, haunted by a tragic accident that took place decades before. When he hears rumors that a white deer has been spotted in the forest—a creature of legend that inspired his father and grandfather—he becomes obsessed with protecting the deer from poachers.\r\n\r\nAs these characters’ fates orbit closer together, none of them is expecting a miracle . . . but that may be exactly what is about to alter their futures forever.', '200000', 300, 150, '4.8', 7, 'f1.jpg,f2.jpg,f3.jpg', '2025-01-18 14:24:26'),
(41, 34, 'Wilson NCAA Final Four Basketball', 'Wilson NCAA Final Four Basketball - Size 6 - 28.5\", Brown\r\nHigh Definition Pebble - Improved Grip\r\nPremium Carcass Construction - Excellent rebound and durability\r\nProper Inflation Level: 7-9 PSI', '300000', 120, 80, '4.4', 8, 'g1.jpg,g2.jpg,g3.jpg', '2025-01-18 14:24:26'),
(42, 35, 'Evenflo Pivot Modular Travel', 'The Evenflo® Pivot® Modular Travel System is the multipurpose stroller you’ve been searching for! This exceptional carriage, stroller and car seat combo is a durable travel system that includes the LiteMax™ Infant Car Seat with Anti-Rebound Bar. The modular frame can be configured with up to 6 modes of use, allowing your child to be parent-facing or forward-facing. The stroller also offers multiple configurations, including carriage mode, toddler mode, or a frame stroller with infant car seat. For comfort, carriage mode allows your baby to fully recline and stretch out. The toddler seat has a maximum weight of 50 lb (22.6 kg), with height recommendations of up to 38 in (96 cm), while the car seat has a maximum weight of 35 lb (15.8 kg) and a maximum height of 32 in (81.28 cm). The LiteMax Infant Car Seat is not only comfortable with a removable body pillow, it has been rollover and side-impact tested. It features an anti-rebound bar that absorbs and dissipates crash forces to help provide additional stability. It includes a stay- in-car base that allows for a quick and easy infant car seat connection. Our integrated belt lock- off system provides peace of mind that the base has been securely installed. The feature-rich stroller includes cruiser tires to make it easy to navigate over multiple surfaces, a large canopy with a peek-a-boo window, an oversized storage basket, a removable bumper bar with cup holder and snack tray, and a convenient self-standing fold.', '150000', 50, 30, '4.9', 9, 'h1.jpg,h2.jpg,h3.jpg', '2025-01-18 14:24:26'),
(43, 36, 'Pacific Foods Organic Vegetable Lentil Soup', 'One (1) 16.3 oz can of Pacific Foods Organic Vegetable Lentil Soup\r\nMade with tender lentils, black beans, fire-roasted red peppers and vine-ripened tomatoes for a delicious vegetarian soup\r\nUSDA Certified Organic vegan soup with non-GMO ingredients and no artificial colors or no added flavors\r\nCanned soup contains 14 grams of protein per can and is a good source of fiber* *See nutrition facts for sodium content\r\nThis plant based vegetarian soup can be microwaved on high for 3 minutes in a covered bowl or a saucepan over medium heat on the stove', '25000', 250, 180, '4.5', 10, 'i1.jpg,i2.jpg,i3.jpg', '2025-01-18 14:24:26');

-- --------------------------------------------------------

--
-- Struktur dari tabel `shipments`
--

CREATE TABLE `shipments` (
  `shipment_id` int(11) NOT NULL,
  `order_idFk` varchar(255) NOT NULL,
  `tracking_number` varchar(255) NOT NULL,
  `courier` varchar(100) NOT NULL,
  `status` enum('pending','in_transit','delivered') NOT NULL DEFAULT 'pending',
  `estimated_delivery` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(200) NOT NULL,
  `password` varchar(250) NOT NULL,
  `verified` tinyint(1) NOT NULL,
  `status` enum('buyer','seller') NOT NULL DEFAULT 'buyer',
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `fullname` varchar(150) DEFAULT NULL,
  `pathFoto` varchar(200) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `birth` date DEFAULT NULL,
  `created_at` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`user_id`, `username`, `email`, `password`, `verified`, `status`, `phone`, `address`, `fullname`, `pathFoto`, `gender`, `birth`, `created_at`) VALUES
(33, 'jaya', 'jaya@gmail.com', '$2a$10$4RI1CxUy0hOuviKQIxoolee0jhTqYzKV3BjMvG6gBSBF4JLn3Ua8S', 1, 'buyer', '9403083480', 'jl.jukut,apakadennah', 'Jaya ananta', '/storage/emulated/0/Android/data/com.progandroid/files/images/rn_image_picker_lib_temp_0729eee3-bf75-454f-9f41-d991cfa217ea.png', 'male', '1998-01-19', '2025-01-18'),
(34, 'siwa', 'siwa@gmail.com', '$2a$10$h4dqT/wNt2XQdj1bfK.l3OHlA5PNJsy.qhQQIY7RHlitzeNYG70mG', 1, 'buyer', '2084874498', NULL, NULL, NULL, NULL, NULL, '2025-01-18'),
(35, 'godvankaka', 'godvankaka@gmail.com', '$2a$10$WuD9lKjWuFvG7MmlvzzXeusnOYVFOcnCGy3IAu2T/st6qHfejG02C', 1, 'buyer', '00829832', NULL, NULL, NULL, NULL, NULL, '2025-01-18'),
(36, 'widiantari', 'widiantari@gmail.com', '$2a$10$nfFTQZlBGuITCRA4r84UyOGHXVcbSRr32bgtIw6WKE2ps27yFJu8i', 1, 'buyer', '08764637336', NULL, NULL, NULL, NULL, NULL, '2025-01-18'),
(37, 'jaksana', 'jaksana@gmail.com', '$2a$10$.FwELsQDC1BcPcODmf7N6O5M9x95vBYK9nmmvXsrslHRiG9ecOAL.', 1, 'buyer', '087665436722', NULL, NULL, NULL, NULL, NULL, '2025-01-18'),
(40, 'mardiana', 'mardianakeliki8@gmail.com', '$2a$10$HW1hulouji/qI/uVrMCl7uGnP2HjLeyOPGui9zgnJVIWUzfRmxcBW', 1, 'buyer', '08537643764838', 'acak acak ahsjha', 'Sang putu mardiana', '/storage/emulated/0/Android/data/com.progandroid/files/images/rn_image_picker_lib_temp_edd4392f-14c8-4fa8-9d75-c0436c9889ce.jpg', 'male', '1951-01-18', '2025-01-19');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `user_IdFk` (`user_idFk`),
  ADD KEY `product_idFk` (`product_idFk`);

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indeks untuk tabel `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `userFk` (`user_idFk`);

--
-- Indeks untuk tabel `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `user_FK` (`user_idFk`),
  ADD KEY `categories_FK` (`category_idFk`);

--
-- Indeks untuk tabel `shipments`
--
ALTER TABLE `shipments`
  ADD PRIMARY KEY (`shipment_id`),
  ADD UNIQUE KEY `tracking_number` (`tracking_number`),
  ADD KEY `Order_idFk` (`order_idFk`);

--
-- Indeks untuk tabel `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT untuk tabel `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT untuk tabel `shipments`
--
ALTER TABLE `shipments`
  MODIFY `shipment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `product_idFk` FOREIGN KEY (`product_idFk`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_IdFk` FOREIGN KEY (`user_idFk`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `shipments`
--
ALTER TABLE `shipments`
  ADD CONSTRAINT `Order_idFk` FOREIGN KEY (`order_idFk`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
