CREATE TABLE `dates` (
  `date` TEXT NOT NULL,
  `penpal` INTEGER NOT NULL,
  `type` INT NOT NULL,
  `direction` INT NOT NULL
);


CREATE TABLE `penpals` (
  `name` TEXT NOT NULL,
  `nickname` TEXT NOT NULL,
  `notes` TEXT NOT NULL,
  `address` TEXT NOT NULL,
  `country` TEXT NOT NULL
);
