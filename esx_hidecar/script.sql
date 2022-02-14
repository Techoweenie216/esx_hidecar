CREATE TABLE `hidden_cars` (
  `owner` varchar(22) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `model` varchar(60) NOT NULL
);

ALTER TABLE `hidden_cars`
  ADD PRIMARY KEY (`plate`);
COMMIT;