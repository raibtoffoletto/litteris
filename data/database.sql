CREATE TABLE `dates` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `date` TEXT NOT NULL,
  `penpal`  NOT NULL,
  `type` TEXT NOT NULL,
  `direction` INT NOT NULL
);

CREATE TABLE `addresses` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `penpal` INT NOT NULL,
  `address` TEXT NOT NULL,
  `country` TEXT NOT NULL
);

CREATE TABLE `penpals` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `nickname` TEXT,
  `notes` TEXT NOT NULL
);
