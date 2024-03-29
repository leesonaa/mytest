#
# TABLE STRUCTURE FOR: ci_account
#

DROP TABLE IF EXISTS ci_account;

CREATE TABLE `ci_account` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT COMMENT '导航栏目',
  `name` varchar(20) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '栏目名称',
  `number` varchar(15) COLLATE utf8_unicode_ci DEFAULT '0',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `amount` double DEFAULT '0',
  `date` date DEFAULT NULL,
  `type` tinyint(1) DEFAULT '1',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `number` (`number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#
# TABLE STRUCTURE FOR: ci_account_info
#

DROP TABLE IF EXISTS ci_account_info;

CREATE TABLE `ci_account_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iid` int(11) DEFAULT '0' COMMENT '关联ID',
  `uid` int(11) DEFAULT '0',
  `buId` smallint(6) DEFAULT '0' COMMENT '客户ID',
  `billNo` varchar(25) DEFAULT '' COMMENT '单号',
  `billType` varchar(20) DEFAULT '',
  `billDate` date DEFAULT NULL COMMENT '单据日期',
  `accId` int(11) DEFAULT '0' COMMENT '结算账户ID',
  `payment` double DEFAULT '0' COMMENT '收款金额  采购退回为正',
  `wayId` int(11) DEFAULT '0' COMMENT '结算方式ID',
  `settlement` varchar(50) DEFAULT '' COMMENT '结算号',
  `remark` varchar(50) DEFAULT '' COMMENT '备注',
  `transType` int(11) DEFAULT '0',
  `transTypeName` varchar(50) DEFAULT '',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `billdate` (`billDate`) USING BTREE,
  KEY `iid` (`iid`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8;

#
# TABLE STRUCTURE FOR: ci_address
#

DROP TABLE IF EXISTS ci_address;

CREATE TABLE `ci_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '导航栏目',
  `shortName` varchar(20) COLLATE utf8_unicode_ci DEFAULT '' COMMENT ' ',
  `postalcode` varchar(50) COLLATE utf8_unicode_ci DEFAULT '',
  `province` varchar(50) COLLATE utf8_unicode_ci DEFAULT '',
  `city` varchar(50) COLLATE utf8_unicode_ci DEFAULT '',
  `area` varchar(50) COLLATE utf8_unicode_ci DEFAULT '',
  `address` varchar(50) COLLATE utf8_unicode_ci DEFAULT '',
  `linkman` varchar(50) COLLATE utf8_unicode_ci DEFAULT '',
  `phone` varchar(20) COLLATE utf8_unicode_ci DEFAULT '',
  `mobile` varchar(20) COLLATE utf8_unicode_ci DEFAULT '',
  `isdefault` tinyint(1) DEFAULT '0',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `pid` (`postalcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#
# TABLE STRUCTURE FOR: ci_admin
#

DROP TABLE IF EXISTS ci_admin;

CREATE TABLE `ci_admin` (
  `uid` smallint(6) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '用户名称',
  `userpwd` varchar(32) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '密码',
  `status` tinyint(1) DEFAULT '1' COMMENT '是否锁定',
  `name` varchar(25) COLLATE utf8_unicode_ci DEFAULT '',
  `mobile` varchar(20) COLLATE utf8_unicode_ci DEFAULT '',
  `lever` text COLLATE utf8_unicode_ci COMMENT '权限',
  `roleid` tinyint(1) DEFAULT '1' COMMENT '角色ID',
  `righttype1` text COLLATE utf8_unicode_ci,
  `righttype2` text COLLATE utf8_unicode_ci,
  `righttype8` text COLLATE utf8_unicode_ci,
  `righttype4` text COLLATE utf8_unicode_ci,
  `rightids` varchar(255) COLLATE utf8_unicode_ci DEFAULT '1,2,4,8',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO ci_admin (`uid`, `username`, `userpwd`, `status`, `name`, `mobile`, `lever`, `roleid`, `righttype1`, `righttype2`, `righttype8`, `righttype4`, `rightids`) VALUES (1, 'admin', '21232f297a57a5a743894a0e4a801fc3', 1, '系统管理员', '13800000000', NULL, 0, NULL, NULL, NULL, NULL, '');


#
# TABLE STRUCTURE FOR: ci_assistingprop
#

DROP TABLE IF EXISTS ci_assistingprop;

CREATE TABLE `ci_assistingprop` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT COMMENT '导航栏目',
  `name` varchar(20) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '栏目名称',
  `disable` tinyint(1) DEFAULT '0' COMMENT '状态',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#
# TABLE STRUCTURE FOR: ci_assistsku
#

DROP TABLE IF EXISTS ci_assistsku;

CREATE TABLE `ci_assistsku` (
  `skuId` int(11) NOT NULL AUTO_INCREMENT,
  `skuClassId` int(11) DEFAULT '0',
  `skuAssistId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `skuName` varchar(100) COLLATE utf8_unicode_ci DEFAULT '',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`skuId`),
  KEY `id` (`skuClassId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#
# TABLE STRUCTURE FOR: ci_category
#

DROP TABLE IF EXISTS ci_category;

CREATE TABLE `ci_category` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT COMMENT '导航栏目',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '栏目名称',
  `parentId` smallint(6) DEFAULT '0' COMMENT '上级栏目ID',
  `path` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '栏目路径',
  `level` tinyint(2) DEFAULT '1' COMMENT '层次',
  `ordnum` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `typeNumber` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '区别',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `detail` tinyint(4) DEFAULT '1',
  `sortIndex` smallint(6) DEFAULT '0',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `parentId` (`parentId`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

INSERT INTO ci_category (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `status`, `typeNumber`, `remark`, `detail`, `sortIndex`, `isDelete`) VALUES (16, '二极管', 0, '16', 1, 0, 1, 'trade', '', 1, 0, 0);
INSERT INTO ci_category (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `status`, `typeNumber`, `remark`, `detail`, `sortIndex`, `isDelete`) VALUES (17, '三极管', 0, '17', 1, 0, 1, 'trade', '', 1, 0, 0);
INSERT INTO ci_category (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `status`, `typeNumber`, `remark`, `detail`, `sortIndex`, `isDelete`) VALUES (18, '电子元器件', 0, '', 1, 0, 1, 'supplytype', '', 1, 0, 0);
INSERT INTO ci_category (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `status`, `typeNumber`, `remark`, `detail`, `sortIndex`, `isDelete`) VALUES (19, '芯片', 0, '', 1, 0, 1, 'supplytype', '', 1, 0, 0);
INSERT INTO ci_category (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `status`, `typeNumber`, `remark`, `detail`, `sortIndex`, `isDelete`) VALUES (20, '客户一', 0, '', 1, 0, 1, 'customertype', '', 1, 0, 0);
INSERT INTO ci_category (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `status`, `typeNumber`, `remark`, `detail`, `sortIndex`, `isDelete`) VALUES (21, '客户二', 0, '', 1, 0, 1, 'customertype', '', 1, 0, 0);


#
# TABLE STRUCTURE FOR: ci_contact
#

DROP TABLE IF EXISTS ci_contact;

CREATE TABLE `ci_contact` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '0' COMMENT '客户名称',
  `number` varchar(50) DEFAULT '0' COMMENT '客户编号',
  `cCategory` smallint(6) DEFAULT '0' COMMENT '客户类别',
  `cCategoryName` varchar(50) DEFAULT '' COMMENT '分类名称',
  `taxRate` double DEFAULT '0' COMMENT '税率',
  `amount` double DEFAULT '0' COMMENT '期初应付款',
  `periodMoney` double DEFAULT '0' COMMENT '期初预付款',
  `difMoney` double DEFAULT '0' COMMENT '初期往来余额',
  `beginDate` date DEFAULT NULL COMMENT '余额日期',
  `remark` varchar(100) DEFAULT '' COMMENT '备注',
  `place` varchar(100) DEFAULT '' COMMENT '职位',
  `linkMans` text COMMENT '客户联系方式',
  `type` tinyint(1) DEFAULT '-10' COMMENT '-10客户  10供应商',
  `contact` varchar(255) DEFAULT '',
  `cLevel` smallint(5) DEFAULT '1' COMMENT '客户等级ID',
  `cLevelName` varchar(50) DEFAULT '' COMMENT '客户等级',
  `pinYin` varchar(50) DEFAULT '',
  `disable` tinyint(1) DEFAULT '0' COMMENT '0启用   1禁用',
  `isDelete` tinyint(1) DEFAULT '0' COMMENT '0正常 1删除',
  PRIMARY KEY (`id`),
  KEY `number` (`number`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

INSERT INTO ci_contact (`id`, `name`, `number`, `cCategory`, `cCategoryName`, `taxRate`, `amount`, `periodMoney`, `difMoney`, `beginDate`, `remark`, `place`, `linkMans`, `type`, `contact`, `cLevel`, `cLevelName`, `pinYin`, `disable`, `isDelete`) VALUES (8, '深圳法本信息', '10001', 20, '客户一', '0', '0', '0', '0', '2022-04-06', '', '', '[]', -10, '', 0, '零售客户', '', 0, 0);
INSERT INTO ci_contact (`id`, `name`, `number`, `cCategory`, `cCategoryName`, `taxRate`, `amount`, `periodMoney`, `difMoney`, `beginDate`, `remark`, `place`, `linkMans`, `type`, `contact`, `cLevel`, `cLevelName`, `pinYin`, `disable`, `isDelete`) VALUES (9, '深圳机电', '10001', 18, '电子元器件', '0', '0', '0', '0', '2022-04-06', '', '', '[]', 10, '', 0, NULL, '', 0, 0);


#
# TABLE STRUCTURE FOR: ci_goods
#

DROP TABLE IF EXISTS ci_goods;

CREATE TABLE `ci_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '',
  `number` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '商品编号',
  `quantity` double DEFAULT '0' COMMENT '起初数量',
  `spec` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '规格',
  `baseUnitId` smallint(6) DEFAULT '0' COMMENT '单位ID',
  `unitName` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '单位名称',
  `categoryId` smallint(6) DEFAULT '0' COMMENT '商品分类ID',
  `categoryName` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '分类名称',
  `purPrice` double DEFAULT '0' COMMENT '预计采购价',
  `salePrice` double DEFAULT '0' COMMENT '预计销售价',
  `unitCost` double DEFAULT '0' COMMENT '单位成本',
  `amount` double DEFAULT '0' COMMENT '期初总价',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `goods` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `propertys` text CHARACTER SET utf8 COLLATE utf8_unicode_ci COMMENT '初期设置',
  `vipPrice` double DEFAULT '0' COMMENT '会员价',
  `lowQty` double DEFAULT '0',
  `length` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `height` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `highQty` double DEFAULT '0',
  `isSerNum` double DEFAULT '0',
  `barCode` varchar(60) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `discountRate1` double DEFAULT '0' COMMENT '0',
  `discountRate2` double DEFAULT '0',
  `locationId` int(11) DEFAULT '0',
  `locationName` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `wholesalePrice` double DEFAULT '0',
  `width` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `skuAssistId` text CHARACTER SET utf8 COLLATE utf8_unicode_ci COMMENT '辅助属性分类',
  `pinYin` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `unitId` smallint(6) DEFAULT '0',
  `files` text CHARACTER SET utf8 COLLATE utf8_unicode_ci COMMENT '图片路径',
  `disable` tinyint(1) DEFAULT '0' COMMENT '0启用   1禁用',
  `unitTypeId` int(11) DEFAULT '0',
  `assistIds` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `assistName` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `assistUnit` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `jianxing` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `josl` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `skuClassId` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `property` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `safeDays` double DEFAULT '0',
  `advanceDay` double DEFAULT '0',
  `isWarranty` double DEFAULT '0',
  `delete` int(11) DEFAULT '0',
  `weight` double DEFAULT '0',
  `isDelete` tinyint(1) DEFAULT '0' COMMENT '0正常  1删除',
  `warehouseWarning` tinyint(1) DEFAULT '0',
  `warehousePropertys` text,
  `dopey` tinyint(1) DEFAULT '0' COMMENT '是否多品',
  `sonGoods` text COMMENT '子商品集合',
  `udf01` varchar(255) DEFAULT '',
  `udf02` varchar(255) DEFAULT '',
  `udf03` varchar(255) DEFAULT '',
  `udf04` varchar(255) DEFAULT '',
  `udf05` varchar(255) DEFAULT '',
  `udf06` text,
  `udf07` text,
  `udf08` text,
  PRIMARY KEY (`id`),
  KEY `number` (`number`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

INSERT INTO ci_goods (`id`, `name`, `number`, `quantity`, `spec`, `baseUnitId`, `unitName`, `categoryId`, `categoryName`, `purPrice`, `salePrice`, `unitCost`, `amount`, `remark`, `status`, `goods`, `propertys`, `vipPrice`, `lowQty`, `length`, `height`, `highQty`, `isSerNum`, `barCode`, `discountRate1`, `discountRate2`, `locationId`, `locationName`, `wholesalePrice`, `width`, `skuAssistId`, `pinYin`, `unitId`, `files`, `disable`, `unitTypeId`, `assistIds`, `assistName`, `assistUnit`, `jianxing`, `josl`, `skuClassId`, `property`, `safeDays`, `advanceDay`, `isWarranty`, `delete`, `weight`, `isDelete`, `warehouseWarning`, `warehousePropertys`, `dopey`, `sonGoods`, `udf01`, `udf02`, `udf03`, `udf04`, `udf05`, `udf06`, `udf07`, `udf08`) VALUES (4, '发光二极管', '10001', '0', '0302', 5, '个', 16, '二极管', '0.32', '0.8', '0', '0', '', 1, '', '[]', '0.6', '0', '', '', '0', '0', '', '0', '0', 0, '', '0.65', '', NULL, 'fgejg', 0, NULL, 0, 0, '', '', '', '', '', '', '', '0', '0', '0', 0, '0', 0, 0, '', 0, '[]', '', '', '', '', '', NULL, NULL, NULL);
INSERT INTO ci_goods (`id`, `name`, `number`, `quantity`, `spec`, `baseUnitId`, `unitName`, `categoryId`, `categoryName`, `purPrice`, `salePrice`, `unitCost`, `amount`, `remark`, `status`, `goods`, `propertys`, `vipPrice`, `lowQty`, `length`, `height`, `highQty`, `isSerNum`, `barCode`, `discountRate1`, `discountRate2`, `locationId`, `locationName`, `wholesalePrice`, `width`, `skuAssistId`, `pinYin`, `unitId`, `files`, `disable`, `unitTypeId`, `assistIds`, `assistName`, `assistUnit`, `jianxing`, `josl`, `skuClassId`, `property`, `safeDays`, `advanceDay`, `isWarranty`, `delete`, `weight`, `isDelete`, `warehouseWarning`, `warehousePropertys`, `dopey`, `sonGoods`, `udf01`, `udf02`, `udf03`, `udf04`, `udf05`, `udf06`, `udf07`, `udf08`) VALUES (5, '三极管', '10002', '0', '1056', 5, '个', 17, '三极管', '0.32', '0.69', '0', '0', '', 1, '', '[]', '0.6', '0', '', '', '0', '0', '', '0', '0', 0, '', '0.65', '', NULL, 'sjg', 0, NULL, 0, 0, '', '', '', '', '', '', '', '0', '0', '0', 0, '0', 0, 0, '', 0, '[]', '', '', '', '', '', NULL, NULL, NULL);
INSERT INTO ci_goods (`id`, `name`, `number`, `quantity`, `spec`, `baseUnitId`, `unitName`, `categoryId`, `categoryName`, `purPrice`, `salePrice`, `unitCost`, `amount`, `remark`, `status`, `goods`, `propertys`, `vipPrice`, `lowQty`, `length`, `height`, `highQty`, `isSerNum`, `barCode`, `discountRate1`, `discountRate2`, `locationId`, `locationName`, `wholesalePrice`, `width`, `skuAssistId`, `pinYin`, `unitId`, `files`, `disable`, `unitTypeId`, `assistIds`, `assistName`, `assistUnit`, `jianxing`, `josl`, `skuClassId`, `property`, `safeDays`, `advanceDay`, `isWarranty`, `delete`, `weight`, `isDelete`, `warehouseWarning`, `warehousePropertys`, `dopey`, `sonGoods`, `udf01`, `udf02`, `udf03`, `udf04`, `udf05`, `udf06`, `udf07`, `udf08`) VALUES (6, '测试商品', '100003', '0', '609', 5, '个', 17, '三极管', '0.36', '0.98', '0', '0', NULL, 1, '', NULL, '0.8', '0', '', '', '0', '0', NULL, '0', '0', 6, '仓库001', '0.86', '', NULL, 'cssp', 0, NULL, 0, 0, '', '', '', '', '', '', '', '0', '0', '0', 0, '0', 0, 0, NULL, 0, '[]', '', '', NULL, NULL, NULL, NULL, NULL, NULL);


#
# TABLE STRUCTURE FOR: ci_goods_img
#

DROP TABLE IF EXISTS ci_goods_img;

CREATE TABLE `ci_goods_img` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '' COMMENT '名称',
  `invId` int(11) DEFAULT '0',
  `type` varchar(100) DEFAULT '',
  `url` varchar(255) DEFAULT '',
  `thumbnailUrl` varchar(255) DEFAULT '',
  `size` int(11) DEFAULT '0',
  `deleteUrl` varchar(255) DEFAULT '',
  `deleteType` varchar(50) DEFAULT '',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `invId` (`invId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

#
# TABLE STRUCTURE FOR: ci_invoice
#

DROP TABLE IF EXISTS ci_invoice;

CREATE TABLE `ci_invoice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `buId` smallint(6) DEFAULT '0' COMMENT '供应商ID',
  `billNo` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '单据编号',
  `uid` smallint(6) DEFAULT '0',
  `userName` varchar(50) DEFAULT '' COMMENT '制单人',
  `transType` int(11) DEFAULT '0' COMMENT '150501购货 150502退货 150601销售 150602退销 150706其他入库',
  `totalAmount` double DEFAULT '0' COMMENT '购货总金额',
  `amount` double DEFAULT '0' COMMENT '折扣后金额',
  `rpAmount` double DEFAULT '0' COMMENT '本次付款',
  `billDate` date DEFAULT NULL COMMENT '单据日期',
  `description` varchar(255) DEFAULT '' COMMENT '备注',
  `arrears` double DEFAULT '0' COMMENT '本次欠款',
  `disRate` double DEFAULT '0' COMMENT '折扣率',
  `disAmount` double DEFAULT '0' COMMENT '折扣金额',
  `totalQty` double DEFAULT '0' COMMENT '总数量',
  `totalArrears` double DEFAULT '0',
  `billStatus` tinyint(1) DEFAULT '0' COMMENT '订单状态 ',
  `checkName` varchar(50) DEFAULT '' COMMENT '采购单审核人',
  `totalTax` double DEFAULT '0',
  `totalTaxAmount` double DEFAULT '0',
  `createTime` datetime DEFAULT NULL,
  `checked` tinyint(1) DEFAULT '0' COMMENT '采购单状态',
  `accId` tinyint(4) DEFAULT '0' COMMENT '结算账户ID',
  `billType` varchar(20) DEFAULT '' COMMENT 'PO采购订单 OI其他入库 PUR采购入库 BAL初期余额',
  `modifyTime` datetime DEFAULT NULL COMMENT '更新时间',
  `hxStateCode` tinyint(4) DEFAULT '0' COMMENT '0未付款  1部分付款  2全部付款',
  `transTypeName` varchar(20) DEFAULT '',
  `totalDiscount` double DEFAULT '0',
  `salesId` smallint(6) DEFAULT '0' COMMENT '销售人员ID',
  `customerFree` double DEFAULT '0' COMMENT '客户承担费用',
  `hxAmount` double DEFAULT '0' COMMENT '本次核销金额',
  `payment` double DEFAULT '0' COMMENT '本次预收款',
  `discount` double DEFAULT '0' COMMENT '整单折扣',
  `srcOrderNo` varchar(255) DEFAULT '' COMMENT '订单编号',
  `srcOrderId` int(11) DEFAULT '0',
  `postData` text COMMENT '提交订单明细 ',
  `locationId` varchar(255) DEFAULT '',
  `inLocationId` varchar(255) DEFAULT '' COMMENT '调入仓库ID多个,分割',
  `outLocationId` varchar(255) DEFAULT '' COMMENT '调出仓库ID多个,分割',
  `paySettacctId` varchar(255) DEFAULT '',
  `recSettacctId` varchar(255) DEFAULT '',
  `isDelete` tinyint(1) DEFAULT '0' COMMENT '1删除  0正常',
  `serialno` text COMMENT '序列号',
  `udf01` varchar(255) DEFAULT '',
  `udf02` varchar(255) DEFAULT '',
  `udf03` varchar(255) DEFAULT '',
  `udf04` varchar(255) DEFAULT '',
  `udf05` varchar(255) DEFAULT '',
  `udf06` text,
  `udf07` text,
  `udf08` text,
  PRIMARY KEY (`id`),
  KEY `accId` (`accId`),
  KEY `buId` (`buId`),
  KEY `salesId` (`salesId`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8;

INSERT INTO ci_invoice (`id`, `buId`, `billNo`, `uid`, `userName`, `transType`, `totalAmount`, `amount`, `rpAmount`, `billDate`, `description`, `arrears`, `disRate`, `disAmount`, `totalQty`, `totalArrears`, `billStatus`, `checkName`, `totalTax`, `totalTaxAmount`, `createTime`, `checked`, `accId`, `billType`, `modifyTime`, `hxStateCode`, `transTypeName`, `totalDiscount`, `salesId`, `customerFree`, `hxAmount`, `payment`, `discount`, `srcOrderNo`, `srcOrderId`, `postData`, `locationId`, `inLocationId`, `outLocationId`, `paySettacctId`, `recSettacctId`, `isDelete`, `serialno`, `udf01`, `udf02`, `udf03`, `udf04`, `udf05`, `udf06`, `udf07`, `udf08`) VALUES (113, 9, 'CG202204062133243', 1, '系统管理员', 150501, '32', '32', '0', '2022-04-06', '', '32', '0', '0', '100', '0', 0, '', '0', '0', '2022-04-06 21:36:08', 0, 0, 'PUR', '2022-04-06 21:36:08', 0, '购货', '0', 0, '0', '0', '0', '0', '0', 0, 'a:29:{s:2:\"id\";i:-1;s:4:\"buId\";i:9;s:11:\"contactName\";s:12:\"深圳机电\";s:4:\"date\";s:10:\"2022-04-06\";s:6:\"billNo\";s:17:\"CG202204062133243\";s:9:\"transType\";i:150501;s:7:\"entries\";a:1:{i:0;a:20:{s:5:\"invId\";s:1:\"4\";s:9:\"invNumber\";s:5:\"10001\";s:7:\"invName\";s:15:\"发光二极管\";s:7:\"invSpec\";s:4:\"0302\";s:5:\"skuId\";i:-1;s:7:\"skuName\";s:0:\"\";s:6:\"unitId\";s:1:\"0\";s:8:\"mainUnit\";s:3:\"个\";s:3:\"qty\";s:6:\"100.00\";s:5:\"price\";s:4:\"0.32\";s:12:\"discountRate\";s:1:\"0\";s:9:\"deduction\";s:4:\"0.00\";s:6:\"amount\";s:5:\"32.00\";s:10:\"locationId\";i:6;s:12:\"locationName\";s:9:\"仓库001\";s:8:\"serialno\";s:0:\"\";s:11:\"description\";s:0:\"\";s:15:\"srcOrderEntryId\";s:0:\"\";s:10:\"srcOrderId\";s:0:\"\";s:10:\"srcOrderNo\";s:0:\"\";}}s:8:\"totalQty\";d:100;s:11:\"totalAmount\";d:32;s:11:\"description\";s:0:\"\";s:8:\"serialno\";s:0:\"\";s:7:\"disRate\";d:0;s:9:\"disAmount\";d:0;s:6:\"amount\";d:32;s:8:\"rpAmount\";d:0;s:7:\"arrears\";d:32;s:12:\"totalArrears\";d:0;s:5:\"accId\";i:0;s:8:\"billType\";s:3:\"PUR\";s:13:\"transTypeName\";s:6:\"购货\";s:8:\"billDate\";s:10:\"2022-04-06\";s:8:\"accounts\";a:0:{}s:11:\"hxStateCode\";i:0;s:3:\"uid\";s:1:\"1\";s:8:\"userName\";s:15:\"系统管理员\";s:10:\"modifyTime\";s:19:\"2022-04-06 21:36:08\";s:10:\"createTime\";s:19:\"2022-04-06 21:36:08\";s:10:\"srcOrderNo\";i:0;s:10:\"srcOrderId\";i:0;}', '', '', '', '', '', 0, '', '', '', '', '', '', NULL, NULL, NULL);
INSERT INTO ci_invoice (`id`, `buId`, `billNo`, `uid`, `userName`, `transType`, `totalAmount`, `amount`, `rpAmount`, `billDate`, `description`, `arrears`, `disRate`, `disAmount`, `totalQty`, `totalArrears`, `billStatus`, `checkName`, `totalTax`, `totalTaxAmount`, `createTime`, `checked`, `accId`, `billType`, `modifyTime`, `hxStateCode`, `transTypeName`, `totalDiscount`, `salesId`, `customerFree`, `hxAmount`, `payment`, `discount`, `srcOrderNo`, `srcOrderId`, `postData`, `locationId`, `inLocationId`, `outLocationId`, `paySettacctId`, `recSettacctId`, `isDelete`, `serialno`, `udf01`, `udf02`, `udf03`, `udf04`, `udf05`, `udf06`, `udf07`, `udf08`) VALUES (114, 9, 'CG202204062225201', 1, '系统管理员', 150501, '32', '32', '0', '2022-04-06', '', '32', '0', '0', '100', '0', 0, '', '0', '0', '2022-04-06 22:26:57', 0, 0, 'PUR', '2022-04-06 22:26:57', 0, '购货', '0', 0, '0', '0', '0', '0', '0', 0, 'a:29:{s:2:\"id\";i:-1;s:4:\"buId\";i:9;s:11:\"contactName\";s:12:\"深圳机电\";s:4:\"date\";s:10:\"2022-04-06\";s:6:\"billNo\";s:17:\"CG202204062225201\";s:9:\"transType\";i:150501;s:7:\"entries\";a:2:{i:0;a:20:{s:5:\"invId\";s:1:\"4\";s:9:\"invNumber\";s:5:\"10001\";s:7:\"invName\";s:15:\"发光二极管\";s:7:\"invSpec\";s:4:\"0302\";s:5:\"skuId\";i:-1;s:7:\"skuName\";s:0:\"\";s:6:\"unitId\";s:1:\"0\";s:8:\"mainUnit\";s:3:\"个\";s:3:\"qty\";s:5:\"50.00\";s:5:\"price\";s:4:\"0.32\";s:12:\"discountRate\";s:1:\"0\";s:9:\"deduction\";s:4:\"0.00\";s:6:\"amount\";s:5:\"16.00\";s:10:\"locationId\";i:6;s:12:\"locationName\";s:9:\"仓库001\";s:8:\"serialno\";s:0:\"\";s:11:\"description\";s:0:\"\";s:15:\"srcOrderEntryId\";s:0:\"\";s:10:\"srcOrderId\";s:0:\"\";s:10:\"srcOrderNo\";s:0:\"\";}i:1;a:20:{s:5:\"invId\";s:1:\"5\";s:9:\"invNumber\";s:5:\"10002\";s:7:\"invName\";s:9:\"三极管\";s:7:\"invSpec\";s:4:\"1056\";s:5:\"skuId\";i:-1;s:7:\"skuName\";s:0:\"\";s:6:\"unitId\";s:1:\"0\";s:8:\"mainUnit\";s:3:\"个\";s:3:\"qty\";s:5:\"50.00\";s:5:\"price\";s:4:\"0.32\";s:12:\"discountRate\";s:1:\"0\";s:9:\"deduction\";s:4:\"0.00\";s:6:\"amount\";s:5:\"16.00\";s:10:\"locationId\";i:6;s:12:\"locationName\";s:9:\"仓库001\";s:8:\"serialno\";s:0:\"\";s:11:\"description\";s:0:\"\";s:15:\"srcOrderEntryId\";s:0:\"\";s:10:\"srcOrderId\";s:0:\"\";s:10:\"srcOrderNo\";s:0:\"\";}}s:8:\"totalQty\";d:100;s:11:\"totalAmount\";d:32;s:11:\"description\";s:0:\"\";s:8:\"serialno\";s:0:\"\";s:7:\"disRate\";d:0;s:9:\"disAmount\";d:0;s:6:\"amount\";d:32;s:8:\"rpAmount\";d:0;s:7:\"arrears\";d:32;s:12:\"totalArrears\";d:0;s:5:\"accId\";i:0;s:8:\"billType\";s:3:\"PUR\";s:13:\"transTypeName\";s:6:\"购货\";s:8:\"billDate\";s:10:\"2022-04-06\";s:8:\"accounts\";a:0:{}s:11:\"hxStateCode\";i:0;s:3:\"uid\";s:1:\"1\";s:8:\"userName\";s:15:\"系统管理员\";s:10:\"modifyTime\";s:19:\"2022-04-06 22:26:57\";s:10:\"createTime\";s:19:\"2022-04-06 22:26:57\";s:10:\"srcOrderNo\";i:0;s:10:\"srcOrderId\";i:0;}', '', '', '', '', '', 0, '', '', '', '', '', '', NULL, NULL, NULL);


#
# TABLE STRUCTURE FOR: ci_invoice_img
#

DROP TABLE IF EXISTS ci_invoice_img;

CREATE TABLE `ci_invoice_img` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '' COMMENT '名称',
  `billNo` varchar(50) DEFAULT '',
  `type` varchar(100) DEFAULT '',
  `url` varchar(255) DEFAULT '',
  `thumbnailUrl` varchar(255) DEFAULT '',
  `size` int(11) DEFAULT '0',
  `deleteUrl` varchar(255) DEFAULT '',
  `deleteType` varchar(50) DEFAULT '',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `invId` (`billNo`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

#
# TABLE STRUCTURE FOR: ci_invoice_info
#

DROP TABLE IF EXISTS ci_invoice_info;

CREATE TABLE `ci_invoice_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iid` int(11) DEFAULT '0' COMMENT '关联ID',
  `buId` smallint(6) DEFAULT '0' COMMENT '供应商ID',
  `billNo` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '单据编号',
  `transType` int(11) DEFAULT '0' COMMENT '150501采购 150502退货',
  `amount` double DEFAULT '0' COMMENT '购货金额',
  `billDate` date DEFAULT NULL COMMENT '单据日期',
  `serialno` text COMMENT '序列号',
  `description` varchar(255) DEFAULT '' COMMENT '备注',
  `invId` int(11) DEFAULT '0' COMMENT '商品ID',
  `price` double DEFAULT '0' COMMENT '单价',
  `deduction` double DEFAULT '0' COMMENT '折扣额',
  `discountRate` double DEFAULT '0' COMMENT '折扣率',
  `qty` double DEFAULT '0' COMMENT '数量',
  `locationId` smallint(6) DEFAULT '0',
  `tax` double DEFAULT '0',
  `taxRate` double DEFAULT '0',
  `taxAmount` double DEFAULT '0',
  `unitId` smallint(6) DEFAULT '0',
  `uid` int(11) DEFAULT '0',
  `skuId` int(11) DEFAULT '0',
  `entryId` tinyint(1) DEFAULT '1' COMMENT '区分调拨单  进和出',
  `transTypeName` varchar(25) DEFAULT '',
  `srcOrderEntryId` int(11) DEFAULT '0',
  `srcOrderId` int(11) DEFAULT '0',
  `srcOrderNo` varchar(25) DEFAULT '',
  `billType` varchar(20) DEFAULT '',
  `salesId` smallint(6) DEFAULT '0',
  `isDelete` tinyint(1) DEFAULT '0' COMMENT '1删除 0正常',
  `srcDopey` varchar(255) DEFAULT '',
  `srcDopeyName` varchar(255) DEFAULT '',
  `udf01` varchar(255) DEFAULT '',
  `udf02` varchar(255) DEFAULT '',
  `udf03` varchar(255) DEFAULT '',
  `udf04` varchar(255) DEFAULT '',
  `udf05` varchar(255) DEFAULT '',
  `udf06` text,
  `udf07` text,
  `udf08` text,
  PRIMARY KEY (`id`),
  KEY `type` (`transType`),
  KEY `billdate` (`billDate`),
  KEY `invId` (`invId`) USING BTREE,
  KEY `transType` (`transType`),
  KEY `iid` (`iid`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=385 DEFAULT CHARSET=utf8;

INSERT INTO ci_invoice_info (`id`, `iid`, `buId`, `billNo`, `transType`, `amount`, `billDate`, `serialno`, `description`, `invId`, `price`, `deduction`, `discountRate`, `qty`, `locationId`, `tax`, `taxRate`, `taxAmount`, `unitId`, `uid`, `skuId`, `entryId`, `transTypeName`, `srcOrderEntryId`, `srcOrderId`, `srcOrderNo`, `billType`, `salesId`, `isDelete`, `srcDopey`, `srcDopeyName`, `udf01`, `udf02`, `udf03`, `udf04`, `udf05`, `udf06`, `udf07`, `udf08`) VALUES (382, 113, 9, 'CG202204062133243', 150501, '32', '2022-04-06', '', '', 4, '0.32', '0', '0', '100', 6, '0', '0', '0', 0, 1, -1, 1, '购货', 0, 0, '', 'PUR', 0, 0, '', '', '', '', '', '', '', NULL, NULL, NULL);
INSERT INTO ci_invoice_info (`id`, `iid`, `buId`, `billNo`, `transType`, `amount`, `billDate`, `serialno`, `description`, `invId`, `price`, `deduction`, `discountRate`, `qty`, `locationId`, `tax`, `taxRate`, `taxAmount`, `unitId`, `uid`, `skuId`, `entryId`, `transTypeName`, `srcOrderEntryId`, `srcOrderId`, `srcOrderNo`, `billType`, `salesId`, `isDelete`, `srcDopey`, `srcDopeyName`, `udf01`, `udf02`, `udf03`, `udf04`, `udf05`, `udf06`, `udf07`, `udf08`) VALUES (383, 114, 9, 'CG202204062225201', 150501, '16', '2022-04-06', '', '', 4, '0.32', '0', '0', '50', 6, '0', '0', '0', 0, 1, -1, 1, '购货', 0, 0, '', 'PUR', 0, 0, '', '', '', '', '', '', '', NULL, NULL, NULL);
INSERT INTO ci_invoice_info (`id`, `iid`, `buId`, `billNo`, `transType`, `amount`, `billDate`, `serialno`, `description`, `invId`, `price`, `deduction`, `discountRate`, `qty`, `locationId`, `tax`, `taxRate`, `taxAmount`, `unitId`, `uid`, `skuId`, `entryId`, `transTypeName`, `srcOrderEntryId`, `srcOrderId`, `srcOrderNo`, `billType`, `salesId`, `isDelete`, `srcDopey`, `srcDopeyName`, `udf01`, `udf02`, `udf03`, `udf04`, `udf05`, `udf06`, `udf07`, `udf08`) VALUES (384, 114, 9, 'CG202204062225201', 150501, '16', '2022-04-06', '', '', 5, '0.32', '0', '0', '50', 6, '0', '0', '0', 0, 1, -1, 1, '购货', 0, 0, '', 'PUR', 0, 0, '', '', '', '', '', '', '', NULL, NULL, NULL);


#
# TABLE STRUCTURE FOR: ci_invoice_type
#

DROP TABLE IF EXISTS ci_invoice_type;

CREATE TABLE `ci_invoice_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT '' COMMENT '名称',
  `inout` tinyint(1) DEFAULT '1' COMMENT '1 入库  -1出库',
  `status` tinyint(1) DEFAULT '1',
  `type` varchar(10) DEFAULT '',
  `default` tinyint(1) DEFAULT '0',
  `number` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

INSERT INTO ci_invoice_type (`id`, `name`, `inout`, `status`, `type`, `default`, `number`) VALUES (1, '其他入库', 1, 1, 'in', 1, 150706);
INSERT INTO ci_invoice_type (`id`, `name`, `inout`, `status`, `type`, `default`, `number`) VALUES (2, '盘盈', 1, 1, 'in', 0, 150701);
INSERT INTO ci_invoice_type (`id`, `name`, `inout`, `status`, `type`, `default`, `number`) VALUES (3, '其他出库', -1, 1, 'out', 1, 150806);
INSERT INTO ci_invoice_type (`id`, `name`, `inout`, `status`, `type`, `default`, `number`) VALUES (4, '盘亏', -1, 1, 'out', 0, 150801);


#
# TABLE STRUCTURE FOR: ci_log
#

DROP TABLE IF EXISTS ci_log;

CREATE TABLE `ci_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` smallint(6) DEFAULT '0' COMMENT '用户ID',
  `ip` varchar(25) DEFAULT '',
  `name` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '姓名',
  `log` text COMMENT '日志内容',
  `type` tinyint(1) DEFAULT '1' COMMENT ' ',
  `loginName` varchar(50) DEFAULT '' COMMENT '用户名',
  `modifyTime` datetime DEFAULT NULL COMMENT '写入日期',
  `operateTypeName` varchar(50) DEFAULT '',
  `adddate` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  KEY `adddate` (`adddate`)
) ENGINE=InnoDB AUTO_INCREMENT=1412 DEFAULT CHARSET=utf8;

INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1385, NULL, '49.118.218.87', NULL, '登陆成功 用户名：admin', 1, NULL, '2020-05-11 02:10:58', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1386, 1, '49.118.218.87', '系统管理员', '系统设置成功', 1, 'admin', '2020-05-11 02:39:33', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1387, NULL, '49.118.218.87', NULL, '登陆成功 用户名：admin', 1, NULL, '2020-05-11 02:43:24', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1388, 1, '49.118.218.87', '系统管理员', '备份与恢复,备份文件名:202005110243574.sql', 1, 'admin', '2020-05-11 02:43:57', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1389, NULL, '49.118.218.87', NULL, '登陆成功 用户名：admin', 1, NULL, '2020-05-11 02:51:38', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1390, 1, '49.118.218.87', '系统管理员', '备份与恢复,备份文件名:202005110254421.sql', 1, 'admin', '2020-05-11 02:54:42', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1391, 1, '49.118.218.87', '系统管理员', '备份与恢复,删除文件名:202005110254421.sql', 1, 'admin', '2020-05-11 02:55:19', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1392, NULL, '49.118.218.87', NULL, '登陆成功 用户名：admin', 1, NULL, '2020-05-11 03:28:39', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1393, NULL, '49.118.218.87', NULL, '登陆成功 用户名：admin', 1, NULL, '2020-05-11 03:29:55', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1394, NULL, '49.118.218.87', NULL, '登陆成功 用户名：admin', 1, NULL, '2020-05-11 03:33:30', '', '2020-05-11');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1395, NULL, '127.0.0.1', NULL, '登陆成功 用户名：admin', 1, NULL, '2022-04-06 10:26:49', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1396, 1, '127.0.0.1', '系统管理员', '新增单位:个', 1, 'admin', '2022-04-06 21:30:34', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1397, 1, '127.0.0.1', '系统管理员', '新增商品类别:二极管', 1, 'admin', '2022-04-06 21:31:35', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1398, 1, '127.0.0.1', '系统管理员', '新增商品类别:三极管', 1, 'admin', '2022-04-06 21:31:45', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1399, 1, '127.0.0.1', '系统管理员', '新增商品:发光二极管', 1, 'admin', '2022-04-06 21:32:41', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1400, 1, '127.0.0.1', '系统管理员', '新增仓库:仓库001', 1, 'admin', '2022-04-06 21:33:18', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1401, 1, '127.0.0.1', '系统管理员', '新增供应商类别:电子元器件', 1, 'admin', '2022-04-06 21:34:10', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1402, 1, '127.0.0.1', '系统管理员', '新增供应商类别:芯片', 1, 'admin', '2022-04-06 21:34:21', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1403, 1, '127.0.0.1', '系统管理员', '新增客户类别:客户一', 1, 'admin', '2022-04-06 21:34:40', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1404, 1, '127.0.0.1', '系统管理员', '新增客户类别:客户二', 1, 'admin', '2022-04-06 21:34:47', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1405, 1, '127.0.0.1', '系统管理员', '新增供应商:深圳法本信息', 1, 'admin', '2022-04-06 21:35:22', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1406, 1, '127.0.0.1', '系统管理员', '新增客户:深圳机电', 1, 'admin', '2022-04-06 21:35:58', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1407, 1, '127.0.0.1', '系统管理员', '新增购货 单据编号：CG202204062133243', 1, 'admin', '2022-04-06 21:36:08', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1408, NULL, '127.0.0.1', NULL, '登陆成功 用户名：admin', 1, NULL, '2022-04-06 21:46:03', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1409, 1, '127.0.0.1', '系统管理员', '新增商品:三极管', 1, 'admin', '2022-04-06 22:26:27', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1410, 1, '127.0.0.1', '系统管理员', '新增购货 单据编号：CG202204062225201', 1, 'admin', '2022-04-06 22:26:57', '', '2022-04-06');
INSERT INTO ci_log (`id`, `userId`, `ip`, `name`, `log`, `type`, `loginName`, `modifyTime`, `operateTypeName`, `adddate`) VALUES (1411, 1, '127.0.0.1', '系统管理员', '下载文件名:商品导入_20220407090955.xls', 1, 'admin', '2022-04-07 09:09:55', '', '2022-04-07');


#
# TABLE STRUCTURE FOR: ci_menu
#

DROP TABLE IF EXISTS ci_menu;

CREATE TABLE `ci_menu` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT COMMENT '导航栏目',
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '栏目名称',
  `parentId` smallint(5) DEFAULT '0' COMMENT '上级栏目ID',
  `path` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '栏目路径',
  `level` tinyint(2) DEFAULT '1' COMMENT '层次',
  `ordnum` smallint(6) DEFAULT '0' COMMENT '排序',
  `module` varchar(50) COLLATE utf8_unicode_ci DEFAULT '',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `typeNumber` varchar(25) COLLATE utf8_unicode_ci DEFAULT '',
  `detail` tinyint(1) DEFAULT '1',
  `sortIndex` smallint(6) DEFAULT '0',
  `isDelete` tinyint(1) DEFAULT '0',
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `parentId` (`parentId`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=206 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (1, '购货单', 0, '1', 1, 99, 'PU_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (2, '新增', 1, '1,2', 2, 99, 'PU_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (3, '修改', 1, '1,3', 2, 99, 'PU_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (4, '删除', 1, '1,4', 2, 99, 'PU_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (5, '导出', 1, '1,5', 2, 99, 'PU_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (6, '销货单', 0, '6', 1, 99, 'SA_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (7, '新增', 6, '6,7', 2, 99, 'SA_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (8, '修改', 6, '6,8', 2, 99, 'SA_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (9, '删除', 6, '6,9', 2, 99, 'SA_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (10, '导出', 6, '6,10', 2, 99, 'SA_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (11, '盘点', 0, '11', 1, 99, 'PD_GENPD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (12, '生成盘点记录', 11, '11,12', 2, 99, 'PD_GENPD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (13, '导出', 11, '11,13', 2, 99, 'PD_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (14, '其他入库单', 0, '14', 1, 99, 'IO_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (15, '新增', 14, '14,15', 2, 99, 'IO_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (16, '修改', 14, '14,16', 2, 99, 'IO_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (17, '删除', 14, '14,17', 2, 99, 'IO_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (18, '其他出库单', 0, '18', 1, 99, 'OO_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (19, '新增', 18, '18,19', 2, 99, 'OO_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (20, '修改', 18, '18,20', 2, 99, 'OO_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (21, '删除', 18, '18,21', 2, 99, 'OO_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (22, '采购明细表', 0, '22', 1, 99, 'PUREOORTDETAIL_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (23, '导出', 22, '22,23', 2, 99, 'PUREOORTDETAIL_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (24, '打印', 22, '22,24', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (25, '采购汇总表（按商品）', 0, '25', 1, 99, 'PUREPORTINV_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (26, '导出', 25, '25,26', 2, 99, 'PUREPORTINV_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (27, '打印', 25, '25,27', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (28, '采购汇总表（按供应商）', 0, '28', 1, 99, 'PUREPORTPUR_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (29, '导出', 28, '28,29', 2, 99, 'PUREPORTPUR_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (30, '打印', 28, '28,30', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (31, '销售明细表', 0, '31', 1, 99, 'SAREPORTDETAIL_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (32, '导出', 31, '31,32', 2, 99, 'SAREPORTDETAIL_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (33, '打印', 31, '31,33', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (34, '销售汇总表（按商品）', 0, '34', 1, 99, 'SAREPORTINV_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (35, '导出', 34, '34,35', 2, 99, 'SAREPORTINV_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (36, '打印', 34, '34,36', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (37, '销售汇总表（按客户）', 0, '37', 1, 99, 'SAREPORTBU_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (38, '导出', 37, '37,38', 2, 99, 'SAREPORTBU_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (39, '打印', 37, '37,39', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (40, '商品库存余额表', 0, '40', 1, 99, 'InvBalanceReport_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (41, '导出', 40, '40,41', 2, 99, 'InvBalanceReport_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (42, '打印', 40, '40,42', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (43, '商品收发明细表', 0, '43', 1, 99, 'DeliverDetailReport_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (44, '导出', 43, '43,44', 2, 99, 'DeliverDetailReport_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (45, '打印', 43, '43,45', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (46, '商品收发汇总表', 0, '46', 1, 99, 'DeliverSummaryReport_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (47, '导出', 46, '46,47', 2, 99, 'DeliverSummaryReport_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (48, '打印', 46, '46,48', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (49, '往来单位欠款表', 0, '49', 1, 99, 'ContactDebtReport_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (50, '导出', 49, '49,50', 2, 99, 'ContactDebtReport_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (51, '打印', 49, '49,51', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (52, '应付账款明细表', 0, '52', 1, 99, 'PAYMENTDETAIL_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (53, '导出', 52, '52,53', 2, 99, 'PAYMENTDETAIL_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (54, '打印', 52, '52,54', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (55, '应收账款明细表', 0, '55', 1, 99, 'RECEIPTDETAIL_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (56, '导出', 55, '55,56', 2, 99, 'RECEIPTDETAIL_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (57, '打印', 55, '55,57', 2, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (58, '客户管理', 0, '58', 1, 99, 'BU_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (59, '新增', 58, '58,59', 2, 99, 'BU_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (60, '修改', 58, '58,60', 2, 99, 'BU_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (61, '删除', 58, '58,61', 2, 99, 'BU_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (62, '导出', 58, '58,62', 2, 99, 'BU_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (63, '供应商管理', 0, '63', 1, 99, 'PUR_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (64, '新增', 63, '63,64', 2, 99, 'PUR_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (65, '修改', 63, '63,65', 2, 99, 'PUR_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (66, '删除', 63, '63,66', 2, 99, 'PUR_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (67, '导出', 63, '63,67', 2, 99, 'PUR_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (68, '商品管理', 0, '68', 1, 99, 'INVENTORY_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (69, '新增', 68, '68,69', 2, 99, 'INVENTORY_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (70, '修改', 68, '68,70', 2, 99, 'INVENTORY_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (71, '删除', 68, '68,71', 2, 99, 'INVENTORY_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (72, '导出', 68, '68,72', 2, 99, 'INVENTORY_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (73, '客户类别', 0, '73', 1, 99, 'BUTYPE_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (74, '新增', 73, '73,74', 2, 99, 'BUTYPE_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (75, '修改', 73, '73,75', 2, 99, 'BUTYPE_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (76, '删除', 73, '73,76', 2, 99, 'BUTYPE_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (77, '计量单位', 0, '77', 1, 99, 'UNIT_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (78, '新增', 77, '77,78', 2, 99, 'UNIT_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (79, '修改', 77, '77,79', 2, 99, 'UNIT_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (80, '删除', 77, '77,80', 2, 99, 'UNIT_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (81, '系统参数', 0, '81', 1, 99, 'PARAMETER', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (82, '权限设置', 0, '82', 1, 99, 'AUTHORITY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (83, '操作日志', 0, '83', 1, 99, 'OPERATE_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (84, '数据备份', 0, '84', 1, 99, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (85, '打印', 1, '1,85', 2, 99, 'PU_PRINT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (86, '审核', 1, '1,86', 2, 0, 'PU_CHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (87, '反审核', 1, '1,87', 2, 0, 'PU_UNCHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (88, '打印', 6, '6,88', 2, 0, 'SA_PRINT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (89, '审核', 6, '6,89', 2, 0, 'SA_CHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (90, '反审核', 6, '6,90', 2, 0, 'SA_UNCHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (91, '禁用', 58, '58,91', 2, 0, 'INVLOCTION_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (92, '启用', 58, '58,92', 2, 0, 'INVLOCTION_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (93, '禁用', 63, '63,93', 2, 0, 'INVLOCTION_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (94, '启用', 63, '63,94', 2, 0, 'INVLOCTION_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (95, '禁用', 68, '68,95', 2, 0, 'INVLOCTION_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (96, '启用', 68, '68,96', 2, 0, 'INVLOCTION_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (97, '职员管理', 0, '97', 1, 0, 'STAFF_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (98, '账号管理', 0, '98', 1, 0, 'SettAcct_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (99, '导入', 11, '11,99', 2, 0, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (100, '审核', 14, '14,100', 2, 0, 'IO_CHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (101, '反审核', 14, '14,101', 2, 0, 'IO_UNCHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (102, '导出', 14, '14,102', 2, 0, 'IO_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (103, '审核', 18, '18,103', 2, 0, 'OO_CHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (104, '反审核', 18, '18,104', 2, 0, 'OO_UNCHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (105, '导出', 18, '18,105', 2, 0, 'OO_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (106, '现金银行报表', 0, '106', 1, 0, 'SettAcctReport_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (107, '打印', 106, '106,107', 2, 0, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (108, '导出', 106, '106,108', 2, 0, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (109, '客户对账单', 0, '109', 1, 0, 'CUSTOMERBALANCE_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (110, '打印', 109, '109,110', 2, 0, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (111, '导出', 109, '109,111', 2, 0, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (112, '供应商对账单', 0, '112', 1, 0, 'SUPPLIERBALANCE_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (113, '打印', 112, '112,113', 2, 0, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (114, '导出', 112, '112,114', 2, 0, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (115, '其他收支明细表', 0, '115', 1, 0, 'ORIDETAIL_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (116, '打印', 115, '115,116', 2, 0, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (117, '导出', 115, '115,117', 2, 0, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (118, '新增', 97, '97,118', 2, 0, 'INVLOCTION_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (119, '修改', 97, '97,119', 2, 0, 'INVLOCTION_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (120, '删除', 97, '97,120', 2, 0, 'INVLOCTION_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (121, '新增', 98, '98,121', 2, 0, 'SettAcct_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (122, '修改', 98, '98,122', 2, 0, 'SettAcct_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (123, '删除', 98, '98,123', 2, 0, 'SettAcct_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (124, '收款单', 0, '124', 1, 0, 'RECEIPT_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (125, '新增', 124, '124,125', 2, 0, 'RECEIPT_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (126, '修改', 124, '124,126', 2, 0, 'RECEIPT_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (127, '删除', 124, '124,127', 2, 0, 'RECEIPT_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (128, '导出', 124, '124,128', 2, 0, 'RECEIPT_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (129, '付款单', 0, '129', 1, 0, 'PAYMENT_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (130, '新增', 129, '129,130', 2, 0, 'PAYMENT_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (131, '修改', 129, '129,131', 2, 0, 'PAYMENT_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (132, '删除', 129, '129,132', 2, 0, 'PAYMENT_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (133, '导出', 129, '129,133', 2, 0, 'PAYMENT_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (134, '其他收入单', 0, '134', 1, 0, 'QTSR_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (135, '新增', 134, '134,135', 2, 0, 'QTSR_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (136, '修改', 134, '134,136', 2, 0, 'QTSR_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (137, '删除', 134, '134,137', 2, 0, 'QTSR_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (138, '导出', 134, '134,138', 2, 0, 'QTSR_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (139, '其他支出单', 0, '139', 1, 0, 'QTZC_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (140, '新增', 139, '139,140', 2, 0, 'QTZC_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (141, '修改', 139, '139,141', 2, 0, 'QTZC_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (142, '删除', 139, '139,142', 2, 0, 'QTZC_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (143, '导出', 139, '139,143', 2, 0, 'QTZC_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (144, '调拨单', 0, '144', 1, 0, 'TF_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (145, '新增', 144, '144,145', 2, 0, 'TF_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (146, '修改', 144, '144,146', 2, 0, 'TF_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (147, '删除', 144, '144,147', 2, 0, 'TF_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (148, '导出', 144, '144,148', 2, 0, 'TF_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (149, '重新初始化', 0, '149', 1, 0, '', 0, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (151, '成本调整单', 0, '151', 1, 0, 'CADJ_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (152, '新增', 151, '151,152', 2, 0, 'CADJ_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (153, '修改', 151, '151,153', 2, 0, 'CADJ_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (154, '删除', 151, '151,154', 2, 0, 'CADJ_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (155, '仓库管理', 0, '155', 1, 0, 'INVLOCTION_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (156, '新增', 155, '155,156', 2, 0, 'INVLOCTION_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (157, '修改', 155, '155,157', 2, 0, 'INVLOCTION_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (158, '删除', 155, '155,158', 2, 0, 'INVLOCTION_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (159, '结算方式', 0, '159', 1, 0, 'Assist_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (160, '新增', 159, '159,160', 2, 0, 'Assist_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (161, '修改', 159, '159,161', 2, 0, 'Assist_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (162, '删除', 159, '159,162', 2, 0, 'Assist_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (163, '供应商类别', 0, '163', 1, 0, 'SUPPLYTYPE_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (164, '新增', 163, '163,164', 2, 0, 'SUPPLYTYPE_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (165, '修改', 163, '163,165', 2, 0, 'SUPPLYTYPE_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (166, '删除', 163, '163,166', 2, 0, 'SUPPLYTYPE_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (167, '商品类别', 0, '167', 1, 0, 'TRADETYPE_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (168, '新增', 167, '167,168', 2, 0, 'TRADETYPE_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (169, '修改', 167, '167,169', 2, 0, 'TRADETYPE_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (170, '删除', 167, '167,170', 2, 0, 'TRADETYPE_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (171, '支出类别', 0, '171', 1, 0, 'PACCTTYPE_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (172, '新增', 171, '171,172', 2, 0, 'PACCTTYPE_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (173, '修改', 171, '171,173', 2, 0, 'PACCTTYPE_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (174, '删除', 171, '171,174', 2, 0, 'PACCTTYPE_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (175, '收入类别', 0, '175', 1, 0, 'RACCTTYPE_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (176, '新增', 175, '175,176', 2, 0, 'RACCTTYPE_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (177, '修改', 175, '175,177', 2, 0, 'RACCTTYPE_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (178, '删除', 175, '175,178', 2, 0, 'RACCTTYPE_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (179, '打印', 144, '144,179', 2, 0, 'TF_PRINT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (180, '采购订单', 0, '180', 1, 0, 'PO_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (181, '新增', 180, '180,181', 2, 0, 'PO_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (182, '修改', 180, '180,182', 2, 0, 'PO_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (183, '删除', 180, '180,183', 2, 0, 'PO_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (184, '导出', 180, '180,184', 2, 0, 'PO_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (185, '打印', 180, '180,185', 2, 0, 'PO_PRINT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (186, '审核', 180, '180,186', 2, 0, 'PO_CHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (187, '反审核', 180, '180,187', 2, 0, 'PO_UNCHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (188, '销售订单', 0, '188', 1, 0, 'SO_QUERY', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (189, '新增', 188, '188,189', 2, 0, 'SO_ADD', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (190, '修改', 188, '188,190', 2, 0, 'SO_UPDATE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (191, '删除', 188, '188,191', 2, 0, 'SO_DELETE', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (192, '导出', 188, '188,192', 2, 0, 'SO_EXPORT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (193, '打印', 188, '188,193', 2, 0, 'SO_PRINT', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (194, '审核', 188, '188,194', 2, 0, 'SO_CHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (195, '反审核', 188, '188,195', 2, 0, 'SO_UNCHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (196, '审核', 144, '144,196', 2, 0, 'TF_CHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (197, '反审核', 144, '144,197', 2, 0, 'TF_UNCHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (198, '审核', 124, '124,198', 2, 0, 'RECEIPT_CHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (199, '反审核', 124, '124,199', 2, 0, 'RECEIPT_UNCHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (200, '审核', 129, '129,200', 2, 0, 'PAYMENT_CHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (201, '反审核', 129, '129,201', 2, 0, 'PAYMENT_UNCHECK', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (202, '库存预警', 0, '202', 1, 0, 'INVENTORY_WARNING', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (203, '合同上传', 1, '1,203', 2, 99, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (204, '合同查看', 1, '1,204', 2, 99, '', 1, 'trade', 1, 0, 0, '');
INSERT INTO ci_menu (`id`, `name`, `parentId`, `path`, `level`, `ordnum`, `module`, `status`, `typeNumber`, `detail`, `sortIndex`, `isDelete`, `remark`) VALUES (205, '合同删除', 1, '1,205', 2, 99, '', 1, 'trade', 1, 0, 0, '');


#
# TABLE STRUCTURE FOR: ci_options
#

DROP TABLE IF EXISTS ci_options;

CREATE TABLE `ci_options` (
  `option_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `option_name` varchar(64) NOT NULL DEFAULT '',
  `option_value` longtext NOT NULL,
  `autoload` varchar(20) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `option_name` (`option_name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (1, 'system', 'a:10:{s:11:\"companyName\";s:26:\"ERP进销存V9多仓库版\";s:11:\"companyAddr\";s:26:\"ERP进销存V9多仓库版\";s:5:\"phone\";s:11:\"12345678901\";s:3:\"fax\";s:11:\"12345678901\";s:8:\"postcode\";s:11:\"12345678901\";s:9:\"qtyPlaces\";s:1:\"2\";s:11:\"pricePlaces\";s:1:\"2\";s:12:\"amountPlaces\";s:1:\"2\";s:10:\"valMethods\";s:13:\"movingAverage\";s:18:\"requiredCheckStore\";s:1:\"1\";}', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (2, 'sales', 's:3893:\"{\"grids\":{\"grid\":{\"defColModel\":[{\"name\":\"operating\",\"label\":\" \",\"width\":60,\"fixed\":true,\"align\":\"center\",\"defLabel\":\" \"},{\"name\":\"goods\",\"label\":\"商品\",\"nameExt\":\"<span id=\\\"barCodeInsert\\\">扫描枪录入</span>\",\"width\":300,\"classes\":\"goods\",\"editable\":true,\"defLabel\":\"商品\"},{\"name\":\"skuId\",\"label\":\"属性ID\",\"hidden\":true,\"defLabel\":\"属性ID\",\"defhidden\":true},{\"name\":\"skuName\",\"label\":\"属性\",\"width\":100,\"classes\":\"ui-ellipsis\",\"hidden\":true,\"defLabel\":\"属性\",\"defhidden\":true},{\"name\":\"mainUnit\",\"label\":\"单位\",\"width\":80,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"单位\"},{\"name\":\"unitId\",\"label\":\"单位Id\",\"hidden\":true,\"defLabel\":\"单位Id\",\"defhidden\":true},{\"name\":\"locationName\",\"label\":\"仓库\",\"nameExt\":\"<small id=\\\"batchStorage\\\">(批量)</small>\",\"width\":100,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"仓库\"},{\"name\":\"batch\",\"label\":\"批次\",\"width\":90,\"classes\":\"ui-ellipsis batch\",\"hidden\":true,\"title\":false,\"editable\":true,\"align\":\"left\",\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-ellipsis\"},\"defLabel\":\"批次\",\"defhidden\":true},{\"name\":\"prodDate\",\"label\":\"生产日期\",\"width\":90,\"hidden\":true,\"title\":false,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{},\"defLabel\":\"生产日期\",\"defhidden\":true},{\"name\":\"safeDays\",\"label\":\"保质期(天)\",\"width\":90,\"hidden\":true,\"title\":false,\"align\":\"left\",\"defLabel\":\"保质期(天)\",\"defhidden\":true},{\"name\":\"validDate\",\"label\":\"有效期至\",\"width\":90,\"hidden\":true,\"title\":false,\"align\":\"left\",\"defLabel\":\"有效期至\",\"defhidden\":true},{\"name\":\"qty\",\"label\":\"数量\",\"width\":80,\"align\":\"right\",\"formatter\":\"number\",\"formatoptions\":{\"decimalPlaces\":1},\"editable\":true,\"defLabel\":\"数量\"},{\"name\":\"price\",\"label\":\"销售单价\",\"hidden\":false,\"width\":100,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":1},\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"销售单价\",\"defhidden\":false},{\"name\":\"discountRate\",\"label\":\"折扣率(%)\",\"hidden\":false,\"width\":70,\"fixed\":true,\"align\":\"right\",\"formatter\":\"integer\",\"editable\":true,\"defLabel\":\"折扣率(%)\",\"defhidden\":false},{\"name\":\"deduction\",\"label\":\"折扣额\",\"hidden\":false,\"width\":70,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":2},\"editable\":true,\"defLabel\":\"折扣额\",\"defhidden\":false},{\"name\":\"amount\",\"label\":\"销售金额\",\"hidden\":false,\"width\":100,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":2},\"editable\":true,\"defLabel\":\"销售金额\",\"defhidden\":false},{\"name\":\"description\",\"label\":\"备注\",\"width\":150,\"title\":true,\"editable\":true,\"defLabel\":\"备注\"},{\"name\":\"srcOrderEntryId\",\"label\":\"源单分录ID\",\"width\":0,\"hidden\":true,\"defLabel\":\"源单分录ID\",\"defhidden\":true},{\"name\":\"srcOrderId\",\"label\":\"源单ID\",\"width\":0,\"hidden\":true,\"defLabel\":\"源单ID\",\"defhidden\":true},{\"name\":\"srcOrderNo\",\"label\":\"源单号\",\"width\":120,\"fixed\":true,\"hidden\":true,\"defLabel\":\"源单号\",\"defhidden\":true}],\"colModel\":[[\"operating\",\" \",null,60],[\"goods\",\"商品\",null,300],[\"skuId\",\"属性ID\",true,null],[\"skuName\",\"属性\",true,100],[\"mainUnit\",\"单位\",null,80],[\"unitId\",\"单位Id\",true,null],[\"locationName\",\"仓库\",null,100],[\"batch\",\"批次\",true,90],[\"prodDate\",\"生产日期\",true,90],[\"safeDays\",\"保质期(天)\",true,90],[\"validDate\",\"有效期至\",true,90],[\"qty\",\"数量\",null,80],[\"price\",\"销售单价\",false,100],[\"discountRate\",\"折扣率(%)\",false,70],[\"deduction\",\"折扣额\",false,70],[\"amount\",\"销售金额\",false,100],[\"description\",\"备注\",null,150],[\"srcOrderEntryId\",\"源单分录ID\",true,0],[\"srcOrderId\",\"源单ID\",true,0],[\"srcOrderNo\",\"源单号\",true,120]],\"isReg\":true}}}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (3, 'purchase', 's:767:\"{\"grids\":{\"grid\":{\"colModel\":[[\"operating\",\" \",null,60],[\"goods\",\"商品\",null,260],[\"skuId\",\"属性ID\",true,null],[\"skuName\",\"属性\",true,100],[\"mainUnit\",\"单位\",null,80],[\"unitId\",\"单位Id\",true,null],[\"locationName\",\"仓库\",null,100],[\"batch\",\"批次\",true,90],[\"prodDate\",\"生产日期\",true,90],[\"safeDays\",\"保质期(天)\",true,90],[\"validDate\",\"有效期至\",true,90],[\"qty\",\"数量\",null,80],[\"price\",\"购货单价\",false,100],[\"discountRate\",\"折扣率(%)\",false,70],[\"deduction\",\"折扣额\",false,70],[\"amount\",\"购货金额\",false,100],[\"description\",\"备注\",null,150],[\"srcOrderEntryId\",\"源单分录ID\",true,0],[\"srcOrderId\",\"源单ID\",true,0],[\"srcOrderNo\",\"源单号\",false,120]],\"isReg\":true}},\"curTime\":1448007624000,\"modifyTime\":1448007624000}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (4, 'transfers', 's:2702:\"{\"grids\":{\"grid\":{\"defColModel\":[{\"name\":\"operating\",\"label\":\" \",\"width\":40,\"fixed\":true,\"align\":\"center\",\"defLabel\":\" \"},{\"name\":\"goods\",\"label\":\"商品\",\"width\":318,\"title\":false,\"classes\":\"goods\",\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-ellipsis\"},\"defLabel\":\"商品\"},{\"name\":\"skuId\",\"label\":\"属性ID\",\"hidden\":true,\"defLabel\":\"属性ID\",\"defhidden\":true},{\"name\":\"skuName\",\"label\":\"属性\",\"width\":100,\"classes\":\"ui-ellipsis\",\"hidden\":true,\"defLabel\":\"属性\",\"defhidden\":true},{\"name\":\"mainUnit\",\"label\":\"单位\",\"width\":80,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"单位\"},{\"name\":\"unitId\",\"label\":\"单位Id\",\"hidden\":true,\"defLabel\":\"单位Id\",\"defhidden\":true},{\"name\":\"batch\",\"label\":\"批次\",\"width\":90,\"classes\":\"ui-ellipsis batch\",\"hidden\":true,\"title\":false,\"editable\":true,\"align\":\"left\",\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-ellipsis\"},\"defLabel\":\"批次\",\"defhidden\":true},{\"name\":\"prodDate\",\"label\":\"生产日期\",\"width\":90,\"hidden\":true,\"title\":false,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{},\"defLabel\":\"生产日期\",\"defhidden\":true},{\"name\":\"safeDays\",\"label\":\"保质期(天)\",\"width\":90,\"hidden\":true,\"title\":false,\"align\":\"left\",\"defLabel\":\"保质期(天)\",\"defhidden\":true},{\"name\":\"validDate\",\"label\":\"有效期至\",\"width\":90,\"hidden\":true,\"title\":false,\"align\":\"left\",\"defLabel\":\"有效期至\",\"defhidden\":true},{\"name\":\"qty\",\"label\":\"数量\",\"width\":80,\"align\":\"right\",\"formatter\":\"number\",\"formatoptions\":{\"decimalPlaces\":1},\"editable\":true,\"defLabel\":\"数量\"},{\"name\":\"outLocationName\",\"label\":\"调出仓库\",\"nameExt\":\"<small id=\\\"batch-storageA\\\">(批量)</small>\",\"sortable\":false,\"width\":100,\"title\":true,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"调出仓库\"},{\"name\":\"inLocationName\",\"label\":\"调入仓库\",\"nameExt\":\"<small id=\\\"batch-storageB\\\">(批量)</small>\",\"width\":100,\"title\":true,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"调入仓库\"},{\"name\":\"description\",\"label\":\"备注\",\"width\":150,\"title\":true,\"editable\":true,\"defLabel\":\"备注\"}],\"colModel\":[[\"operating\",\" \",null,40],[\"goods\",\"商品\",null,318],[\"skuId\",\"属性ID\",true,null],[\"skuName\",\"属性\",true,100],[\"mainUnit\",\"单位\",null,80],[\"unitId\",\"单位Id\",true,null],[\"batch\",\"批次\",true,90],[\"prodDate\",\"生产日期\",true,90],[\"safeDays\",\"保质期(天)\",true,90],[\"validDate\",\"有效期至\",true,90],[\"qty\",\"数量\",null,80],[\"outLocationName\",\"调出仓库\",null,100],[\"inLocationName\",\"调入仓库\",null,100],[\"description\",\"备注\",null,150]],\"isReg\":true}}}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (5, 'otherWarehouse', 's:2906:\"{\"grids\":{\"grid\":{\"defColModel\":[{\"name\":\"operating\",\"label\":\" \",\"width\":40,\"fixed\":true,\"align\":\"center\",\"defLabel\":\" \"},{\"name\":\"goods\",\"label\":\"商品\",\"width\":320,\"title\":true,\"classes\":\"goods\",\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-ellipsis\"},\"defLabel\":\"商品\"},{\"name\":\"skuId\",\"label\":\"属性ID\",\"hidden\":true,\"defLabel\":\"属性ID\",\"defhidden\":true},{\"name\":\"skuName\",\"label\":\"属性\",\"width\":100,\"classes\":\"ui-ellipsis\",\"hidden\":true,\"defLabel\":\"属性\",\"defhidden\":true},{\"name\":\"mainUnit\",\"label\":\"单位\",\"width\":80,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"单位\"},{\"name\":\"unitId\",\"label\":\"单位Id\",\"hidden\":true,\"defLabel\":\"单位Id\",\"defhidden\":true},{\"name\":\"locationName\",\"label\":\"仓库\",\"nameExt\":\"<small id=\\\"batchStorage\\\">(批量)</small>\",\"width\":100,\"title\":true,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"仓库\"},{\"name\":\"batch\",\"label\":\"批次\",\"width\":90,\"classes\":\"ui-ellipsis batch\",\"hidden\":true,\"title\":false,\"editable\":true,\"align\":\"left\",\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-ellipsis\"},\"defLabel\":\"批次\",\"defhidden\":true},{\"name\":\"prodDate\",\"label\":\"生产日期\",\"width\":90,\"hidden\":true,\"title\":false,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{},\"defLabel\":\"生产日期\",\"defhidden\":true},{\"name\":\"safeDays\",\"label\":\"保质期(天)\",\"width\":90,\"hidden\":true,\"title\":false,\"align\":\"left\",\"defLabel\":\"保质期(天)\",\"defhidden\":true},{\"name\":\"validDate\",\"label\":\"有效期至\",\"width\":90,\"hidden\":true,\"title\":false,\"align\":\"left\",\"defLabel\":\"有效期至\",\"defhidden\":true},{\"name\":\"qty\",\"label\":\"数量\",\"width\":80,\"align\":\"right\",\"formatter\":\"number\",\"formatoptions\":{\"decimalPlaces\":1},\"editable\":true,\"defLabel\":\"数量\"},{\"name\":\"price\",\"label\":\"入库单价\",\"hidden\":false,\"width\":100,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":1},\"editable\":true,\"defLabel\":\"入库单价\",\"defhidden\":false},{\"name\":\"amount\",\"label\":\"入库金额\",\"hidden\":false,\"width\":100,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":2},\"editable\":true,\"defLabel\":\"入库金额\",\"defhidden\":false},{\"name\":\"description\",\"label\":\"备注\",\"width\":150,\"title\":true,\"editable\":true,\"defLabel\":\"备注\"}],\"colModel\":[[\"operating\",\" \",null,40],[\"goods\",\"商品\",null,320],[\"skuId\",\"属性ID\",true,null],[\"skuName\",\"属性\",true,100],[\"mainUnit\",\"单位\",null,80],[\"unitId\",\"单位Id\",true,null],[\"locationName\",\"仓库\",null,100],[\"batch\",\"批次\",true,90],[\"prodDate\",\"生产日期\",true,90],[\"safeDays\",\"保质期(天)\",true,90],[\"validDate\",\"有效期至\",true,90],[\"qty\",\"数量\",null,80],[\"price\",\"入库单价\",false,100],[\"amount\",\"入库金额\",false,100],[\"description\",\"备注\",null,150]],\"isReg\":true}}}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (6, 'adjustment', 's:1337:\"{\"grids\":{\"grid\":{\"defColModel\":[{\"name\":\"operating\",\"label\":\" \",\"width\":40,\"fixed\":true,\"align\":\"center\",\"defLabel\":\" \"},{\"name\":\"goods\",\"label\":\"商品\",\"width\":320,\"title\":true,\"classes\":\"goods\",\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-ellipsis disableSku\"},\"defLabel\":\"商品\"},{\"name\":\"skuId\",\"label\":\"属性ID\",\"hidden\":true,\"defLabel\":\"属性ID\",\"defhidden\":true},{\"name\":\"mainUnit\",\"label\":\"单位\",\"width\":60,\"defLabel\":\"单位\"},{\"name\":\"amount\",\"label\":\"调整金额\",\"hidden\":false,\"width\":100,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":2},\"editable\":true,\"defLabel\":\"调整金额\",\"defhidden\":false},{\"name\":\"locationName\",\"label\":\"仓库<small id=\\\"batchStorage\\\">(批量)</small>\",\"width\":100,\"title\":true,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"仓库<small id=\\\"batchStorage\\\">(批量)</small>\"},{\"name\":\"description\",\"label\":\"备注\",\"width\":150,\"title\":true,\"editable\":true,\"defLabel\":\"备注\"}],\"colModel\":[[\"operating\",\" \",null,40],[\"goods\",\"商品\",null,320],[\"skuId\",\"属性ID\",true,null],[\"mainUnit\",\"单位\",null,60],[\"amount\",\"调整金额\",false,100],[\"locationName\",\"仓库<small id=\\\"batchStorage\\\">(批量)</small>\",null,100],[\"description\",\"备注\",null,150]],\"isReg\":true}}}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (7, 'purchaseBack', 'b:0;', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (8, 'salesBack', 's:3893:\"{\"grids\":{\"grid\":{\"defColModel\":[{\"name\":\"operating\",\"label\":\" \",\"width\":60,\"fixed\":true,\"align\":\"center\",\"defLabel\":\" \"},{\"name\":\"goods\",\"label\":\"商品\",\"nameExt\":\"<span id=\\\"barCodeInsert\\\">扫描枪录入</span>\",\"width\":300,\"classes\":\"goods\",\"editable\":true,\"defLabel\":\"商品\"},{\"name\":\"skuId\",\"label\":\"属性ID\",\"hidden\":true,\"defLabel\":\"属性ID\",\"defhidden\":true},{\"name\":\"skuName\",\"label\":\"属性\",\"width\":100,\"classes\":\"ui-ellipsis\",\"hidden\":true,\"defLabel\":\"属性\",\"defhidden\":true},{\"name\":\"mainUnit\",\"label\":\"单位\",\"width\":80,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"单位\"},{\"name\":\"unitId\",\"label\":\"单位Id\",\"hidden\":true,\"defLabel\":\"单位Id\",\"defhidden\":true},{\"name\":\"locationName\",\"label\":\"仓库\",\"nameExt\":\"<small id=\\\"batchStorage\\\">(批量)</small>\",\"width\":100,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"仓库\"},{\"name\":\"batch\",\"label\":\"批次\",\"width\":90,\"classes\":\"ui-ellipsis batch\",\"hidden\":true,\"title\":false,\"editable\":true,\"align\":\"left\",\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-ellipsis\"},\"defLabel\":\"批次\",\"defhidden\":true},{\"name\":\"prodDate\",\"label\":\"生产日期\",\"width\":90,\"hidden\":true,\"title\":false,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{},\"defLabel\":\"生产日期\",\"defhidden\":true},{\"name\":\"safeDays\",\"label\":\"保质期(天)\",\"width\":90,\"hidden\":true,\"title\":false,\"align\":\"left\",\"defLabel\":\"保质期(天)\",\"defhidden\":true},{\"name\":\"validDate\",\"label\":\"有效期至\",\"width\":90,\"hidden\":true,\"title\":false,\"align\":\"left\",\"defLabel\":\"有效期至\",\"defhidden\":true},{\"name\":\"qty\",\"label\":\"数量\",\"width\":80,\"align\":\"right\",\"formatter\":\"number\",\"formatoptions\":{\"decimalPlaces\":2},\"editable\":true,\"defLabel\":\"数量\"},{\"name\":\"price\",\"label\":\"销售单价\",\"hidden\":false,\"width\":100,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":2},\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"销售单价\",\"defhidden\":false},{\"name\":\"discountRate\",\"label\":\"折扣率(%)\",\"hidden\":false,\"width\":70,\"fixed\":true,\"align\":\"right\",\"formatter\":\"integer\",\"editable\":true,\"defLabel\":\"折扣率(%)\",\"defhidden\":false},{\"name\":\"deduction\",\"label\":\"折扣额\",\"hidden\":false,\"width\":70,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":2},\"editable\":true,\"defLabel\":\"折扣额\",\"defhidden\":false},{\"name\":\"amount\",\"label\":\"销售金额\",\"hidden\":false,\"width\":100,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":2},\"editable\":true,\"defLabel\":\"销售金额\",\"defhidden\":false},{\"name\":\"description\",\"label\":\"备注\",\"width\":150,\"title\":true,\"editable\":true,\"defLabel\":\"备注\"},{\"name\":\"srcOrderEntryId\",\"label\":\"源单分录ID\",\"width\":0,\"hidden\":true,\"defLabel\":\"源单分录ID\",\"defhidden\":true},{\"name\":\"srcOrderId\",\"label\":\"源单ID\",\"width\":0,\"hidden\":true,\"defLabel\":\"源单ID\",\"defhidden\":true},{\"name\":\"srcOrderNo\",\"label\":\"源单号\",\"width\":120,\"fixed\":true,\"hidden\":true,\"defLabel\":\"源单号\",\"defhidden\":true}],\"colModel\":[[\"operating\",\" \",null,60],[\"goods\",\"商品\",null,300],[\"skuId\",\"属性ID\",true,null],[\"skuName\",\"属性\",true,100],[\"mainUnit\",\"单位\",null,80],[\"unitId\",\"单位Id\",true,null],[\"locationName\",\"仓库\",null,100],[\"batch\",\"批次\",true,90],[\"prodDate\",\"生产日期\",true,90],[\"safeDays\",\"保质期(天)\",true,90],[\"validDate\",\"有效期至\",true,90],[\"qty\",\"数量\",null,80],[\"price\",\"销售单价\",false,100],[\"discountRate\",\"折扣率(%)\",false,70],[\"deduction\",\"折扣额\",false,70],[\"amount\",\"销售金额\",false,100],[\"description\",\"备注\",null,150],[\"srcOrderEntryId\",\"源单分录ID\",true,0],[\"srcOrderId\",\"源单ID\",true,0],[\"srcOrderNo\",\"源单号\",true,120]],\"isReg\":true}}}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (9, 'otherOutbound', 's:583:\"{\"grids\":{\"grid\":{\"colModel\":[[\"operating\",\" \",null,40],[\"goods\",\"商品\",null,320],[\"skuId\",\"属性ID\",true,null],[\"skuName\",\"属性\",true,100],[\"mainUnit\",\"单位\",null,80],[\"unitId\",\"单位Id\",true,null],[\"locationName\",\"仓库\",null,100],[\"batch\",\"批次\",true,90],[\"prodDate\",\"生产日期\",true,90],[\"safeDays\",\"保质期(天)\",true,90],[\"validDate\",\"有效期至\",true,90],[\"qty\",\"数量\",null,80],[\"price\",\"出库单位成本\",false,100],[\"amount\",\"出库成本\",false,100],[\"description\",\"备注\",null,150]],\"isReg\":true}},\"curTime\":1445235745000,\"modifyTime\":1445235745000}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (10, 'purchaseOrder', 's:2682:\"{\"grids\":{\"grid\":{\"defColModel\":[{\"name\":\"operating\",\"label\":\" \",\"width\":60,\"fixed\":true,\"align\":\"center\",\"defLabel\":\" \"},{\"name\":\"goods\",\"label\":\"商品\",\"nameExt\":\"<span id=\\\"barCodeInsert\\\">扫描枪录入</span>\",\"width\":300,\"classes\":\"goods\",\"editable\":true,\"defLabel\":\"商品\"},{\"name\":\"skuId\",\"label\":\"属性ID\",\"hidden\":true,\"defLabel\":\"属性ID\",\"defhidden\":true},{\"name\":\"skuName\",\"label\":\"属性\",\"width\":100,\"classes\":\"ui-ellipsis\",\"hidden\":true,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"属性\",\"defhidden\":true},{\"name\":\"mainUnit\",\"label\":\"单位\",\"width\":80,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"单位\"},{\"name\":\"unitId\",\"label\":\"单位Id\",\"hidden\":true,\"defLabel\":\"单位Id\",\"defhidden\":true},{\"name\":\"locationName\",\"label\":\"仓库\",\"nameExt\":\"<small id=\\\"batchStorage\\\">(批量)</small>\",\"width\":100,\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"仓库\"},{\"name\":\"qty\",\"label\":\"数量\",\"width\":80,\"align\":\"right\",\"formatter\":\"number\",\"formatoptions\":{\"decimalPlaces\":1},\"editable\":true,\"defLabel\":\"数量\"},{\"name\":\"price\",\"label\":\"购货单价\",\"hidden\":false,\"width\":100,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":1},\"editable\":true,\"edittype\":\"custom\",\"editoptions\":{\"trigger\":\"ui-icon-triangle-1-s\"},\"defLabel\":\"购货单价\",\"defhidden\":false},{\"name\":\"discountRate\",\"label\":\"折扣率(%)\",\"hidden\":false,\"width\":70,\"fixed\":true,\"align\":\"right\",\"formatter\":\"integer\",\"editable\":true,\"defLabel\":\"折扣率(%)\",\"defhidden\":false},{\"name\":\"deduction\",\"label\":\"折扣额\",\"hidden\":false,\"width\":70,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":2},\"editable\":true,\"defLabel\":\"折扣额\",\"defhidden\":false},{\"name\":\"amount\",\"label\":\"购货金额\",\"hidden\":false,\"width\":100,\"fixed\":true,\"align\":\"right\",\"formatter\":\"currency\",\"formatoptions\":{\"showZero\":true,\"decimalPlaces\":2},\"editable\":true,\"defLabel\":\"购货金额\",\"defhidden\":false},{\"name\":\"description\",\"label\":\"备注\",\"width\":150,\"title\":true,\"editable\":true,\"defLabel\":\"备注\"}],\"colModel\":[[\"operating\",\" \",null,60],[\"goods\",\"商品\",null,300],[\"skuId\",\"属性ID\",true,null],[\"skuName\",\"属性\",true,100],[\"mainUnit\",\"单位\",null,80],[\"unitId\",\"单位Id\",true,null],[\"locationName\",\"仓库\",null,100],[\"qty\",\"数量\",null,80],[\"price\",\"购货单价\",false,100],[\"discountRate\",\"折扣率(%)\",false,70],[\"deduction\",\"折扣额\",false,70],[\"amount\",\"购货金额\",false,100],[\"description\",\"备注\",null,150]],\"isReg\":true}}}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (11, 'salesOrderList', 's:523:\"{\"grids\":{\"grid\":{\"colModel\":[[\"operating\",\"操作\",null,60],[\"billDate\",\"订单日期\",null,100],[\"billNo\",\"订单编号\",null,145],[\"transType\",\"业务类别\",null,100],[\"contactName\",\"客户\",null,200],[\"totalAmount\",\"金额\",false,100],[\"totalQty\",\"数量\",null,80],[\"billStatusName\",\"订单状态\",null,100],[\"userName\",\"制单人\",null,80],[\"checkName\",\"审核人\",false,80],[\"description\",\"备注\",null,200],[\"disEditable\",\"不可编辑\",null,null]],\"isReg\":true}},\"curTime\":1447057437000,\"modifyTime\":1447057437000}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (12, 'puDetailNew', 's:536:\"{\"grids\":{\"grid\":{\"colModel\":[[\"date\",\"采购日期\",null,80],[\"billNo\",\"采购单据号\",null,200],[\"transType\",\"业务类别\",null,60],[\"buName\",\"供应商\",null,100],[\"invNo\",\"商品编号\",null,80],[\"invName\",\"商品名称\",null,120],[\"spec\",\"规格型号\",null,120],[\"unit\",\"单位\",false,60],[\"location\",\"仓库\",false,100],[\"qty\",\"数量\",null,100],[\"unitPrice\",\"单价\",false,120],[\"amount\",\"采购金额\",false,120],[\"billId\",\"\",null,0],[\"billType\",\"\",null,0]],\"isReg\":true}},\"curTime\":1440733035000,\"modifyTime\":1440733035000}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (13, 'accountPayDetailNew', 'b:0;', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (14, 'otherIncomeExpenseDetail', 's:368:\"{\"grids\":{\"grid\":{\"colModel\":[[\"date\",\"日期\",null,150],[\"billNo\",\"单据编号\",null,110],[\"transTypeName\",\"收支类别\",null,110],[\"typeName\",\"收支项目\",null,110],[\"amountIn\",\"收入\",null,120],[\"amountOut\",\"支出\",null,120],[\"contactName\",\"往来单位\",null,110],[\"desc\",\"摘要\",null,110]],\"isReg\":true}},\"curTime\":1440738089000,\"modifyTime\":1440738089000}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (15, 'purchaseOrderList', 's:573:\"{\"grids\":{\"grid\":{\"colModel\":[[\"operating\",\"操作\",null,60],[\"billDate\",\"订单日期\",null,100],[\"billNo\",\"订单编号\",null,216],[\"transType\",\"业务类别\",null,100],[\"contactName\",\"供应商\",null,200],[\"totalAmount\",\"购货金额\",false,100],[\"totalQty\",\"数量\",null,80],[\"billStatusName\",\"订单状态\",null,100],[\"deliveryDate\",\"交货日期\",null,100],[\"userName\",\"制单人\",null,80],[\"checkName\",\"审核人\",false,80],[\"description\",\"备注\",null,200],[\"disEditable\",\"不可编辑\",null,null]],\"isReg\":true}},\"curTime\":1446105838000,\"modifyTime\":1446105838000}\";', 'yes');
INSERT INTO ci_options (`option_id`, `option_name`, `option_value`, `autoload`) VALUES (16, 'salesOrder', 'b:0;', 'yes');


#
# TABLE STRUCTURE FOR: ci_order
#

DROP TABLE IF EXISTS ci_order;

CREATE TABLE `ci_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `buId` smallint(6) DEFAULT '0' COMMENT '供应商ID',
  `billNo` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '单据编号',
  `uid` smallint(6) DEFAULT '0',
  `userName` varchar(50) DEFAULT '' COMMENT '制单人',
  `transType` int(11) DEFAULT '0' COMMENT '150501购货 150502退货 150601销售 150602退销 150706其他入库',
  `totalAmount` double DEFAULT '0' COMMENT '购货总金额',
  `amount` double DEFAULT '0' COMMENT '折扣后金额',
  `rpAmount` double DEFAULT '0' COMMENT '本次付款',
  `billDate` date DEFAULT NULL COMMENT '单据日期',
  `description` varchar(100) DEFAULT '' COMMENT '备注',
  `arrears` double DEFAULT '0' COMMENT '本次欠款',
  `disRate` double DEFAULT '0' COMMENT '折扣率',
  `disAmount` double DEFAULT '0' COMMENT '折扣金额',
  `totalQty` double DEFAULT '0' COMMENT '总数量',
  `totalArrears` double DEFAULT '0',
  `billStatus` tinyint(1) DEFAULT '0' COMMENT '订单状态 ',
  `checkName` varchar(50) DEFAULT '' COMMENT '采购单审核人',
  `totalTax` double DEFAULT '0',
  `totalTaxAmount` double DEFAULT '0',
  `checked` tinyint(1) DEFAULT '0' COMMENT '采购单状态',
  `accId` tinyint(4) DEFAULT '0' COMMENT '结算账户ID',
  `billType` varchar(20) DEFAULT '' COMMENT 'PO采购订单 OI其他入库 PUR采购入库 BAL初期余额',
  `modifyTime` datetime DEFAULT NULL COMMENT '更新时间',
  `hxStateCode` tinyint(4) DEFAULT '0' COMMENT '0未付款  1部分付款  2全部付款',
  `transTypeName` varchar(20) DEFAULT '',
  `totalDiscount` double DEFAULT '0',
  `salesId` smallint(6) DEFAULT '0' COMMENT '销售人员ID',
  `customerFree` double DEFAULT '0' COMMENT '客户承担费用',
  `hxAmount` double DEFAULT '0' COMMENT '本次核销金额',
  `hasCheck` double DEFAULT '0' COMMENT '已核销',
  `notCheck` double DEFAULT '0' COMMENT '未核销',
  `nowCheck` double DEFAULT '0' COMMENT '本次核销',
  `payment` double DEFAULT '0' COMMENT '本次预收款',
  `discount` double DEFAULT '0' COMMENT '整单折扣',
  `postData` text COMMENT '提交订单明细 ',
  `locationId` varchar(255) DEFAULT '',
  `inLocationId` varchar(255) DEFAULT '' COMMENT '调入仓库ID多个,分割',
  `outLocationId` varchar(255) DEFAULT '' COMMENT '调出仓库ID多个,分割',
  `isDelete` tinyint(1) DEFAULT '0' COMMENT '1删除  0正常',
  `deliveryDate` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accId` (`accId`),
  KEY `buId` (`buId`),
  KEY `salesId` (`salesId`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

#
# TABLE STRUCTURE FOR: ci_order_info
#

DROP TABLE IF EXISTS ci_order_info;

CREATE TABLE `ci_order_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iid` int(11) DEFAULT '0' COMMENT '关联ID',
  `buId` smallint(6) DEFAULT '0' COMMENT '供应商ID',
  `billNo` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '单据编号',
  `transType` int(11) DEFAULT '0' COMMENT '150501采购 150502退货',
  `amount` double DEFAULT '0' COMMENT '购货金额',
  `billDate` date DEFAULT NULL COMMENT '单据日期',
  `description` varchar(50) DEFAULT '' COMMENT '备注',
  `invId` int(11) DEFAULT '0' COMMENT '商品ID',
  `price` double DEFAULT '0' COMMENT '单价',
  `deduction` double DEFAULT '0' COMMENT '折扣额',
  `discountRate` double DEFAULT '0' COMMENT '折扣率',
  `qty` double DEFAULT '0' COMMENT '数量',
  `locationId` smallint(6) DEFAULT '0',
  `tax` double DEFAULT '0',
  `taxRate` double DEFAULT '0',
  `taxAmount` double DEFAULT '0',
  `unitId` smallint(6) DEFAULT '0',
  `uid` int(11) DEFAULT '0',
  `skuId` int(11) DEFAULT '0',
  `entryId` tinyint(1) DEFAULT '1' COMMENT '区分调拨单  进和出',
  `transTypeName` varchar(25) DEFAULT '',
  `srcOrderEntryId` int(11) DEFAULT '0',
  `srcOrderId` int(11) DEFAULT '0',
  `srcOrderNo` varchar(25) DEFAULT '',
  `billType` varchar(20) DEFAULT '',
  `salesId` smallint(6) DEFAULT '0',
  `isDelete` tinyint(1) DEFAULT '0' COMMENT '1删除 0正常',
  PRIMARY KEY (`id`),
  KEY `type` (`transType`),
  KEY `billdate` (`billDate`),
  KEY `invId` (`invId`) USING BTREE,
  KEY `transType` (`transType`),
  KEY `iid` (`iid`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8;

#
# TABLE STRUCTURE FOR: ci_staff
#

DROP TABLE IF EXISTS ci_staff;

CREATE TABLE `ci_staff` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT COMMENT '导航栏目',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '栏目名称',
  `number` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '0',
  `disable` tinyint(1) DEFAULT '0' COMMENT '0启用  1禁用',
  `allowsms` tinyint(4) DEFAULT '0',
  `birthday` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `commissionrate` tinyint(4) DEFAULT '0',
  `creatorId` int(11) DEFAULT '0',
  `deptId` int(11) DEFAULT '0',
  `description` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `empId` int(11) DEFAULT '0',
  `empType` tinyint(4) DEFAULT '1',
  `fullId` int(11) DEFAULT '0',
  `leftDate` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `mobile` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `parentId` smallint(6) DEFAULT NULL,
  `sex` tinyint(4) DEFAULT NULL,
  `userName` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `number` (`number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

#
# TABLE STRUCTURE FOR: ci_storage
#

DROP TABLE IF EXISTS ci_storage;

CREATE TABLE `ci_storage` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT COMMENT '导航栏目',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '栏目名称',
  `locationNo` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '0',
  `disable` tinyint(1) DEFAULT '0' COMMENT '状态 0正常  1锁定',
  `allowNeg` tinyint(4) DEFAULT '0',
  `deptId` int(11) DEFAULT '0',
  `empId` int(11) DEFAULT '0',
  `groupx` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `type` tinyint(4) DEFAULT '0',
  `address` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `isDelete` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `locationNo` (`locationNo`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

INSERT INTO ci_storage (`id`, `name`, `locationNo`, `disable`, `allowNeg`, `deptId`, `empId`, `groupx`, `phone`, `type`, `address`, `isDelete`) VALUES (6, '仓库001', '10001', 0, 0, 0, 0, '', '', 0, '', 0);


#
# TABLE STRUCTURE FOR: ci_unit
#

DROP TABLE IF EXISTS ci_unit;

CREATE TABLE `ci_unit` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '客户名称',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `unitTypeId` smallint(6) DEFAULT '0',
  `default` tinyint(1) DEFAULT '0',
  `rate` tinyint(1) DEFAULT '0',
  `guid` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

INSERT INTO ci_unit (`id`, `name`, `status`, `unitTypeId`, `default`, `rate`, `guid`, `isDelete`) VALUES (5, '个', 1, 0, 0, 0, '', 0);


#
# TABLE STRUCTURE FOR: ci_unittype
#

DROP TABLE IF EXISTS ci_unittype;

CREATE TABLE `ci_unittype` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '客户名称',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

#
# TABLE STRUCTURE FOR: ci_verifica_info
#

DROP TABLE IF EXISTS ci_verifica_info;

CREATE TABLE `ci_verifica_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iid` int(11) DEFAULT '0' COMMENT '关联ID',
  `buId` smallint(6) DEFAULT '0' COMMENT '客户ID',
  `billId` int(11) DEFAULT '0' COMMENT '销售单号ID',
  `billNo` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '' COMMENT '单编号',
  `billType` varchar(20) DEFAULT '',
  `transType` varchar(50) DEFAULT '',
  `billDate` date DEFAULT NULL,
  `billPrice` double DEFAULT NULL,
  `nowCheck` double DEFAULT '0' COMMENT '本次核销',
  `hasCheck` double DEFAULT '0' COMMENT '已核销',
  `notCheck` double DEFAULT '0' COMMENT '未核销',
  `checked` tinyint(1) DEFAULT '0',
  `isDelete` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# TABLE STRUCTURE FOR: ci_warehouse
#

DROP TABLE IF EXISTS ci_warehouse;

CREATE TABLE `ci_warehouse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invId` int(11) DEFAULT '0' COMMENT '商品ID',
  `highQty` double DEFAULT '0' COMMENT '供应商ID',
  `lowQty` double DEFAULT '0',
  `locationId` smallint(6) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `invId` (`invId`) USING BTREE,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

