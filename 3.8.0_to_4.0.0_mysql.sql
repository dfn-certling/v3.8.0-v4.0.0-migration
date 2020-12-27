-- Adding new fields, creating/updating indices and foreign keys.

ALTER TABLE `COMPONENT`
    ADD COLUMN `AUTHOR` VARCHAR(255) AFTER `ID`,
    ADD COLUMN `BLAKE2B_256` VARCHAR(64) AFTER `AUTHOR`,
    ADD COLUMN `BLAKE2B_384` VARCHAR(96) AFTER `BLAKE2B_256`,
    ADD COLUMN `BLAKE2B_512` VARCHAR(128) AFTER `BLAKE2B_384`,
    ADD COLUMN `BLAKE3` VARCHAR(255) AFTER `BLAKE2B_512`,
    ADD COLUMN `PROJECT_ID` BIGINT(20) NOT NULL AFTER `PARENT_COMPONENT_ID`,
    ADD COLUMN `PUBLISHER` VARCHAR(255) AFTER `PROJECT_ID`,
    ADD COLUMN `PURLCOORDINATES` VARCHAR(255) AFTER `PURL`,
    ADD COLUMN `SHA_384` VARCHAR(96) AFTER `SHA_256`,
    ADD COLUMN `SHA3_384` VARCHAR(96) AFTER `SHA3_256`,
    ADD COLUMN `SWIDTAGID` VARCHAR(255) AFTER `SHA_512`;

ALTER TABLE `COMPONENT`
    DROP FOREIGN KEY `COMPONENT_FK1`,
    DROP FOREIGN KEY `COMPONENT_FK2`;

DROP INDEX `COMPONENT_N49` ON `COMPONENT`;
DROP INDEX `COMPONENT_N50` ON `COMPONENT`;

CREATE INDEX `COMPONENT_BLAKE2B_256_IDX` ON `COMPONENT` (`BLAKE2B_256`);
CREATE INDEX `COMPONENT_BLAKE2B_384_IDX` ON `COMPONENT` (`BLAKE2B_384`);
CREATE INDEX `COMPONENT_BLAKE2B_512_IDX` ON `COMPONENT` (`BLAKE2B_512`);
CREATE INDEX `COMPONENT_BLAKE3_IDX` ON `COMPONENT` (`BLAKE3`);
CREATE INDEX `COMPONENT_CPE_IDX` ON `COMPONENT` (`CPE`);
CREATE INDEX `COMPONENT_N49` ON `COMPONENT` (`PROJECT_ID`);
CREATE INDEX `COMPONENT_N50` ON `COMPONENT` (`PARENT_COMPONENT_ID`);
CREATE INDEX `COMPONENT_N51` ON `COMPONENT` (`LICENSE_ID`);
CREATE INDEX `COMPONENT_PURL_IDX` ON `COMPONENT` (`PURL`);
CREATE INDEX `COMPONENT_PURL_COORDINATES_IDX` ON `COMPONENT` (`PURLCOORDINATES`);
CREATE INDEX `COMPONENT_SHA384_IDX` ON `COMPONENT` (`SHA_384`);
CREATE INDEX `COMPONENT_SHA3_384_IDX` ON `COMPONENT` (`SHA3_384`);
CREATE INDEX `COMPONENT_SWID_TAGID_IDX` ON `COMPONENT` (`SWIDTAGID`);


ALTER TABLE `COMPONENTANALYSISCACHE`
    ADD COLUMN `RESULT` MEDIUMTEXT AFTER `LAST_OCCURRENCE`;


ALTER TABLE `DEPENDENCYMETRICS`
    ADD COLUMN `POLICYVIOLATIONS_AUDITED` INT(11) AFTER `MEDIUM`,
    ADD COLUMN `POLICYVIOLATIONS_FAIL` INT(11) AFTER `POLICYVIOLATIONS_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_INFO` INT(11) AFTER `POLICYVIOLATIONS_FAIL`,
    ADD COLUMN `POLICYVIOLATIONS_LICENSE_AUDITED` INT(11) AFTER `POLICYVIOLATIONS_INFO`,
    ADD COLUMN `POLICYVIOLATIONS_LICENSE_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_LICENSE_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_LICENSE_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_LICENSE_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_OPERATIONAL_AUDITED` INT(11) AFTER `POLICYVIOLATIONS_LICENSE_UNAUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_OPERATIONAL_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_OPERATIONAL_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_OPERATIONAL_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_OPERATIONAL_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_SECURITY_AUDITED` INT(11) AFTER `POLICYVIOLATIONS_OPERATIONAL_UNAUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_SECURITY_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_SECURITY_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_SECURITY_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_SECURITY_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_SECURITY_UNAUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_WARN` INT(11) AFTER `POLICYVIOLATIONS_UNAUDITED`;

UPDATE `DEPENDENCYMETRICS`
SET `POLICYVIOLATIONS_AUDITED` = 0,
    `POLICYVIOLATIONS_FAIL` = 0,
    `POLICYVIOLATIONS_INFO` = 0,
    `POLICYVIOLATIONS_LICENSE_AUDITED` = 0,
    `POLICYVIOLATIONS_LICENSE_TOTAL` = 0,
    `POLICYVIOLATIONS_LICENSE_UNAUDITED` = 0,
    `POLICYVIOLATIONS_OPERATIONAL_AUDITED` = 0,
    `POLICYVIOLATIONS_OPERATIONAL_TOTAL` = 0,
    `POLICYVIOLATIONS_OPERATIONAL_UNAUDITED` = 0,
    `POLICYVIOLATIONS_SECURITY_AUDITED` = 0,
    `POLICYVIOLATIONS_SECURITY_TOTAL` = 0,
    `POLICYVIOLATIONS_SECURITY_UNAUDITED` = 0,
    `POLICYVIOLATIONS_TOTAL` = 0,
    `POLICYVIOLATIONS_UNAUDITED` = 0,
    `POLICYVIOLATIONS_WARN` = 0;


CREATE TABLE `FINDINGATTRIBUTION` (
    `ID` BIGINT(20) NOT NULL AUTO_INCREMENT,
    `ALT_ID` VARCHAR(255),
    `ANALYZERIDENTITY` VARCHAR(255) NOT NULL,
    `ATTRIBUTED_ON` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `COMPONENT_ID` BIGINT(20) NOT NULL,
    `PROJECT_ID` BIGINT(20) NOT NULL,
    `REFERENCE_URL` VARCHAR(255),
    `UUID` VARCHAR(36) NOT NULL,
    `VULNERABILITY_ID` BIGINT(20) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `FINDINGATTRIBUTION_UUID_IDX` (`UUID`),
    KEY `FINDINGATTRIBUTION_N50` (`VULNERABILITY_ID`),
    KEY `FINDINGATTRIBUTION_N51` (`COMPONENT_ID`),
    KEY `FINDINGATTRIBUTION_COMPOUND_IDX` (`COMPONENT_ID`,`VULNERABILITY_ID`),
    KEY `FINDINGATTRIBUTION_N49` (`PROJECT_ID`),
    CONSTRAINT `FINDINGATTRIBUTION_FK2` FOREIGN KEY (`PROJECT_ID`) REFERENCES `PROJECT` (`ID`),
    CONSTRAINT `FINDINGATTRIBUTION_FK3` FOREIGN KEY (`VULNERABILITY_ID`) REFERENCES `VULNERABILITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


CREATE TABLE `LICENSEGROUP` (
    `ID` bigint(20) NOT NULL AUTO_INCREMENT,
    `NAME` varchar(255) NOT NULL,
    `RISKWEIGHT` int(11) NOT NULL,
    `UUID` varchar(36) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `LICENSEGROUP_UUID_IDX` (`UUID`),
    KEY `LICENSEGROUP_NAME_IDX` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

CREATE TABLE `LICENSEGROUP_LICENSE` (
    `LICENSEGROUP_ID` bigint(20) NOT NULL,
    `LICENSE_ID` bigint(20) NOT NULL,
    KEY `LICENSEGROUP_LICENSE_N49` (`LICENSE_ID`),
    KEY `LICENSEGROUP_LICENSE_N50` (`LICENSEGROUP_ID`),
    CONSTRAINT `LICENSEGROUP_LICENSE_FK1` FOREIGN KEY (`LICENSEGROUP_ID`) REFERENCES `LICENSEGROUP` (`ID`),
    CONSTRAINT `LICENSEGROUP_LICENSE_FK2` FOREIGN KEY (`LICENSE_ID`) REFERENCES `LICENSE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


CREATE TABLE `OIDCGROUP` (
    `ID` bigint(20) NOT NULL AUTO_INCREMENT,
    `NAME` varchar(1024) NOT NULL,
    `UUID` varchar(36) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `OIDCGROUP_UUID_IDX` (`UUID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


CREATE TABLE `MAPPEDOIDCGROUP` (
    `ID` bigint(20) NOT NULL AUTO_INCREMENT,
    `GROUP_ID` bigint(20) NOT NULL,
    `TEAM_ID` bigint(20) NOT NULL,
    `UUID` varchar(36) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `MAPPEDOIDCGROUP_UUID_IDX` (`UUID`),
    UNIQUE KEY `MAPPEDOIDCGROUP_U1` (`TEAM_ID`,`GROUP_ID`),
    KEY `MAPPEDOIDCGROUP_N50` (`TEAM_ID`),
    KEY `MAPPEDOIDCGROUP_N49` (`GROUP_ID`),
    CONSTRAINT `MAPPEDOIDCGROUP_FK1` FOREIGN KEY (`GROUP_ID`) REFERENCES `OIDCGROUP` (`ID`),
    CONSTRAINT `MAPPEDOIDCGROUP_FK2` FOREIGN KEY (`TEAM_ID`) REFERENCES `TEAM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


CREATE TABLE `OIDCUSER` (
    `ID` bigint(20) NOT NULL AUTO_INCREMENT,
    `SUBJECT_IDENTIFIER` varchar(255),
    `USERNAME` varchar(255) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `OIDCUSER_USERNAME_IDX` (`USERNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


CREATE TABLE `OIDCUSERS_PERMISSIONS` (
    `PERMISSION_ID` bigint(20) NOT NULL,
    `OIDCUSER_ID` bigint(20) NOT NULL,
    KEY `OIDCUSERS_PERMISSIONS_N49` (`PERMISSION_ID`),
    KEY `OIDCUSERS_PERMISSIONS_N50` (`OIDCUSER_ID`),
    CONSTRAINT `OIDCUSERS_PERMISSIONS_FK1` FOREIGN KEY (`PERMISSION_ID`) REFERENCES `PERMISSION` (`ID`),
    CONSTRAINT `OIDCUSERS_PERMISSIONS_FK2` FOREIGN KEY (`OIDCUSER_ID`) REFERENCES `OIDCUSER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


CREATE TABLE `OIDCUSERS_TEAMS` (
    `OIDCUSERS_ID` bigint(20) NOT NULL,
    `TEAM_ID` bigint(20) NOT NULL,
    KEY `OIDCUSERS_TEAMS_N49` (`OIDCUSERS_ID`),
    KEY `OIDCUSERS_TEAMS_N50` (`TEAM_ID`),
    CONSTRAINT `OIDCUSERS_TEAMS_FK1` FOREIGN KEY (`OIDCUSERS_ID`) REFERENCES `OIDCUSER` (`ID`),
    CONSTRAINT `OIDCUSERS_TEAMS_FK2` FOREIGN KEY (`TEAM_ID`) REFERENCES `TEAM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


CREATE TABLE `POLICY` (
    `ID` bigint(20) NOT NULL AUTO_INCREMENT,
    `NAME` varchar(255) NOT NULL,
    `OPERATOR` varchar(255) NOT NULL,
    `UUID` varchar(36) NOT NULL,
    `VIOLATIONSTATE` varchar(255) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `POLICY_UUID_IDX` (`UUID`),
    KEY `POLICY_NAME_IDX` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

CREATE TABLE `POLICYCONDITION` (
    `ID` bigint(20) NOT NULL AUTO_INCREMENT,
    `OPERATOR` varchar(255) NOT NULL,
    `POLICY_ID` bigint(20) NOT NULL,
    `SUBJECT` varchar(255) NOT NULL,
    `UUID` varchar(36) NOT NULL,
    `VALUE` varchar(255) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `POLICYCONDITION_UUID_IDX` (`UUID`),
    KEY `POLICYCONDITION_N49` (`POLICY_ID`),
    CONSTRAINT `POLICYCONDITION_FK1` FOREIGN KEY (`POLICY_ID`) REFERENCES `POLICY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

CREATE TABLE `POLICYVIOLATION` (
    `ID` bigint(20) NOT NULL AUTO_INCREMENT,
    `COMPONENT_ID` bigint(20) NOT NULL,
    `POLICYCONDITION_ID` bigint(20) NOT NULL,
    `PROJECT_ID` bigint(20) NOT NULL,
    `TEXT` varchar(255),
    `TIMESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `TYPE` varchar(255) NOT NULL,
    `UUID` varchar(36) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `POLICYVIOLATION_UUID_IDX` (`UUID`),
    KEY `POLICYVIOLATION_PROJECT_IDX` (`PROJECT_ID`),
    KEY `POLICYVIOLATION_N49` (`POLICYCONDITION_ID`),
    KEY `POLICYVIOLATION_COMPONENT_IDX` (`COMPONENT_ID`),
    CONSTRAINT `POLICYVIOLATION_FK2` FOREIGN KEY (`POLICYCONDITION_ID`) REFERENCES `POLICYCONDITION` (`ID`),
    CONSTRAINT `POLICYVIOLATION_FK3` FOREIGN KEY (`PROJECT_ID`) REFERENCES `PROJECT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

CREATE TABLE `POLICY_PROJECTS` (
    `POLICY_ID` bigint(20) NOT NULL,
    `PROJECT_ID` bigint(20) DEFAULT NULL,
    KEY `POLICY_PROJECTS_N49` (`PROJECT_ID`),
    KEY `POLICY_PROJECTS_N50` (`POLICY_ID`),
    CONSTRAINT `POLICY_PROJECTS_FK1` FOREIGN KEY (`POLICY_ID`) REFERENCES `POLICY` (`ID`),
    CONSTRAINT `POLICY_PROJECTS_FK2` FOREIGN KEY (`PROJECT_ID`) REFERENCES `PROJECT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


ALTER TABLE `PORTFOLIOMETRICS`
    ADD COLUMN `POLICYVIOLATIONS_AUDITED` INT(11) AFTER `MEDIUM`,
    ADD COLUMN `POLICYVIOLATIONS_FAIL` INT(11) AFTER `POLICYVIOLATIONS_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_INFO` INT(11) AFTER `POLICYVIOLATIONS_FAIL`,
    ADD COLUMN `POLICYVIOLATIONS_LICENSE_AUDITED` INT(11) AFTER `POLICYVIOLATIONS_INFO`,
    ADD COLUMN `POLICYVIOLATIONS_LICENSE_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_LICENSE_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_LICENSE_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_LICENSE_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_OPERATIONAL_AUDITED` INT(11) AFTER `POLICYVIOLATIONS_LICENSE_UNAUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_OPERATIONAL_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_OPERATIONAL_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_OPERATIONAL_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_OPERATIONAL_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_SECURITY_AUDITED` INT(11) AFTER `POLICYVIOLATIONS_OPERATIONAL_UNAUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_SECURITY_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_SECURITY_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_SECURITY_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_SECURITY_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_SECURITY_UNAUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_WARN` INT(11) AFTER `POLICYVIOLATIONS_UNAUDITED`,
    DROP COLUMN `DEPENDENCIES`,
    DROP COLUMN `VULNERABLEDEPENDENCIES`;

UPDATE `PORTFOLIOMETRICS`
SET `POLICYVIOLATIONS_AUDITED` = 0,
    `POLICYVIOLATIONS_FAIL` = 0,
    `POLICYVIOLATIONS_INFO` = 0,
    `POLICYVIOLATIONS_LICENSE_AUDITED` = 0,
    `POLICYVIOLATIONS_LICENSE_TOTAL` = 0,
    `POLICYVIOLATIONS_LICENSE_UNAUDITED` = 0,
    `POLICYVIOLATIONS_OPERATIONAL_AUDITED` = 0,
    `POLICYVIOLATIONS_OPERATIONAL_TOTAL` = 0,
    `POLICYVIOLATIONS_OPERATIONAL_UNAUDITED` = 0,
    `POLICYVIOLATIONS_SECURITY_AUDITED` = 0,
    `POLICYVIOLATIONS_SECURITY_TOTAL` = 0,
    `POLICYVIOLATIONS_SECURITY_UNAUDITED` = 0,
    `POLICYVIOLATIONS_TOTAL` = 0,
    `POLICYVIOLATIONS_UNAUDITED` = 0,
    `POLICYVIOLATIONS_WARN` = 0;


ALTER TABLE `PROJECT`
    ADD COLUMN `AUTHOR` VARCHAR(255) AFTER `ACTIVE`,
    ADD COLUMN `CLASSIFIER` VARCHAR(255) AFTER `AUTHOR`,
    ADD COLUMN `CPE` VARCHAR(255) AFTER `CLASSIFIER`,
    ADD COLUMN `GROUP` VARCHAR(255) AFTER `DESCRIPTION`,
    ADD COLUMN `PUBLISHER` VARCHAR(255) AFTER `PARENT_PROJECT_ID`,
    ADD COLUMN `SWIDTAGID` VARCHAR(255) AFTER `PURL`;

CREATE INDEX `PROJECT_CLASSIFIER_IDX` ON `PROJECT` (`CLASSIFIER`);
CREATE INDEX `PROJECT_CPE_IDX` ON `PROJECT` (`CPE`);
CREATE INDEX `PROJECT_GROUP_IDX` ON `PROJECT` (`GROUP`);
CREATE INDEX `PROJECT_PURL_IDX` ON `PROJECT` (`PURL`);
CREATE INDEX `PROJECT_SWID_TAGID_IDX` ON `PROJECT` (`SWIDTAGID`);


ALTER TABLE `PROJECTMETRICS`
    ADD COLUMN `POLICYVIOLATIONS_AUDITED` INT(11) AFTER `MEDIUM`,
    ADD COLUMN `POLICYVIOLATIONS_FAIL` INT(11) AFTER `POLICYVIOLATIONS_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_INFO` INT(11) AFTER `POLICYVIOLATIONS_FAIL`,
    ADD COLUMN `POLICYVIOLATIONS_LICENSE_AUDITED` INT(11) AFTER `POLICYVIOLATIONS_INFO`,
    ADD COLUMN `POLICYVIOLATIONS_LICENSE_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_LICENSE_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_LICENSE_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_LICENSE_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_OPERATIONAL_AUDITED` INT(11) AFTER `POLICYVIOLATIONS_LICENSE_UNAUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_OPERATIONAL_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_OPERATIONAL_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_OPERATIONAL_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_OPERATIONAL_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_SECURITY_AUDITED` INT(11) AFTER `POLICYVIOLATIONS_OPERATIONAL_UNAUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_SECURITY_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_SECURITY_AUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_SECURITY_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_SECURITY_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_TOTAL` INT(11) AFTER `POLICYVIOLATIONS_SECURITY_UNAUDITED`,
    ADD COLUMN `POLICYVIOLATIONS_UNAUDITED` INT(11) AFTER `POLICYVIOLATIONS_TOTAL`,
    ADD COLUMN `POLICYVIOLATIONS_WARN` INT(11) AFTER `POLICYVIOLATIONS_UNAUDITED`;

UPDATE `PROJECTMETRICS`
SET `POLICYVIOLATIONS_AUDITED` = 0,
    `POLICYVIOLATIONS_FAIL` = 0,
    `POLICYVIOLATIONS_INFO` = 0,
    `POLICYVIOLATIONS_LICENSE_AUDITED` = 0,
    `POLICYVIOLATIONS_LICENSE_TOTAL` = 0,
    `POLICYVIOLATIONS_LICENSE_UNAUDITED` = 0,
    `POLICYVIOLATIONS_OPERATIONAL_AUDITED` = 0,
    `POLICYVIOLATIONS_OPERATIONAL_TOTAL` = 0,
    `POLICYVIOLATIONS_OPERATIONAL_UNAUDITED` = 0,
    `POLICYVIOLATIONS_SECURITY_AUDITED` = 0,
    `POLICYVIOLATIONS_SECURITY_TOTAL` = 0,
    `POLICYVIOLATIONS_SECURITY_UNAUDITED` = 0,
    `POLICYVIOLATIONS_TOTAL` = 0,
    `POLICYVIOLATIONS_UNAUDITED` = 0,
    `POLICYVIOLATIONS_WARN` = 0;



CREATE TABLE `VIOLATIONANALYSIS` (
    `ID` bigint(20) NOT NULL AUTO_INCREMENT,
    `STATE` varchar(255) NOT NULL,
    `COMPONENT_ID` bigint(20) DEFAULT NULL,
    `POLICYVIOLATION_ID` bigint(20) NOT NULL,
    `PROJECT_ID` bigint(20) DEFAULT NULL,
    `SUPPRESSED` bit(1) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `VIOLATIONANALYSIS_COMPOSITE_IDX` (`PROJECT_ID`,`COMPONENT_ID`,`POLICYVIOLATION_ID`),
    KEY `VIOLATIONANALYSIS_N49` (`COMPONENT_ID`),
    KEY `VIOLATIONANALYSIS_N51` (`POLICYVIOLATION_ID`),
    KEY `VIOLATIONANALYSIS_N50` (`PROJECT_ID`),
    CONSTRAINT `VIOLATIONANALYSIS_FK2` FOREIGN KEY (`POLICYVIOLATION_ID`) REFERENCES `POLICYVIOLATION` (`ID`),
    CONSTRAINT `VIOLATIONANALYSIS_FK3` FOREIGN KEY (`PROJECT_ID`) REFERENCES `PROJECT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


CREATE TABLE `VIOLATIONANALYSISCOMMENT` (
    `ID` bigint(20) NOT NULL AUTO_INCREMENT,
    `COMMENT` mediumtext NOT NULL,
    `COMMENTER` varchar(255),
    `TIMESTAMP` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `VIOLATIONANALYSIS_ID` bigint(20) NOT NULL,
    PRIMARY KEY (`ID`),
    KEY `VIOLATIONANALYSISCOMMENT_N49` (`VIOLATIONANALYSIS_ID`),
    CONSTRAINT `VIOLATIONANALYSISCOMMENT_FK1` FOREIGN KEY (`VIOLATIONANALYSIS_ID`) REFERENCES `VIOLATIONANALYSIS` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;


ALTER TABLE `VULNERABILITY` ADD COLUMN `FRIENDLYVULNID` VARCHAR(255) AFTER `DESCRIPTION`;


DROP TABLE `BOMS_COMPONENTS`;


DROP TABLE `COMPONENTMETRICS`;


DROP TABLE `CPEREFERENCE`;


-- Updating the COMPONENT table's rows to match the new structure.
-- This includes the multiplication of the components for each applicable project.


ALTER TABLE `ANALYSIS` DROP FOREIGN KEY `ANALYSIS_FK1`;
ALTER TABLE `COMPONENTS_VULNERABILITIES` DROP FOREIGN KEY `COMPONENTS_VULNERABILITIES_FK1`;
ALTER TABLE `DEPENDENCY` DROP FOREIGN KEY `DEPENDENCY_FK1`;
ALTER TABLE `DEPENDENCYMETRICS` DROP FOREIGN KEY `DEPENDENCYMETRICS_FK1`;

CREATE TABLE `TMP_COMPONENT_MAPPING` (
    `ORIGINAL_COMPONENT_ID` BIGINT(20),
    `NEW_COMPONENT_ID` BIGINT(20),
    `PROJECT_ID` BIGINT(20)
);

CREATE TABLE `COMPONENT_40` LIKE `COMPONENT`;
CREATE TABLE `COMPONENTS_VULNERABILITIES_40` LIKE `COMPONENTS_VULNERABILITIES`;

DELIMITER $$

CREATE PROCEDURE convert_components()
BEGIN
    DECLARE v_original_id BIGINT(20);
    DECLARE v_classifier VARCHAR(255);
    DECLARE v_copyright VARCHAR(1024);
    DECLARE v_cpe VARCHAR(255);
    DECLARE v_description VARCHAR(1024);
    DECLARE v_extension VARCHAR(255);
    DECLARE v_filename VARCHAR(255);
    DECLARE v_group VARCHAR(255);
    DECLARE v_internal BIT(1);
    DECLARE v_last_riskscore DOUBLE;
    DECLARE v_license VARCHAR(255);
    DECLARE v_md5 VARCHAR(32);
    DECLARE v_name VARCHAR(255);
    DECLARE v_parent_component_id BIGINT(20);
    DECLARE v_purl VARCHAR(255);
    DECLARE v_license_id BIGINT(20);
    DECLARE v_sha1 VARCHAR(40);
    DECLARE v_sha_256 VARCHAR(64);
    DECLARE v_sha3_256 VARCHAR(64);
    DECLARE v_sha3_512 VARCHAR(128);
    DECLARE v_sha_512 VARCHAR(128);
    DECLARE v_uuid VARCHAR(36);
    DECLARE v_version VARCHAR(255);
    DECLARE v_project_id BIGINT(20);

    DECLARE v_query_count BIGINT(20);
    DECLARE v_new_id BIGINT(20);

    DECLARE v_done BIT DEFAULT FALSE;
    DECLARE component_cursor CURSOR FOR
        SELECT c.`ID`, c.`CLASSIFIER`, c.`COPYRIGHT`, c.`CPE`, c.`DESCRIPTION`, c.`EXTENSION`, c.`FILENAME`,
               c.`GROUP`, c.`INTERNAL`, c.`LAST_RISKSCORE`, c.`LICENSE`, c.`MD5`, c.`NAME`,
               c.`PARENT_COMPONENT_ID`, c.`PURL`, c.`LICENSE_ID`, c.`SHA1`, c.`SHA_256`,c.`SHA3_256`,
               c.`SHA3_512`, c.`SHA_512`, c.`UUID`, c.`VERSION`, d.`PROJECT_ID`
        FROM `COMPONENT` c
            JOIN `DEPENDENCY` d ON c.`ID` = d.`COMPONENT_ID`
        GROUP BY `ID`, `PROJECT_ID`;
    DECLARE mapping_cursor CURSOR FOR
        SELECT `ORIGINAL_COMPONENT_ID`, `NEW_COMPONENT_ID`, `PROJECT_ID`
        FROM `TMP_COMPONENT_MAPPING`
        ORDER BY `ORIGINAL_COMPONENT_ID` DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    OPEN component_cursor;

    component_loop: LOOP
        FETCH component_cursor INTO v_original_id, v_classifier, v_copyright, v_cpe, v_description,
            v_extension, v_filename, v_group, v_internal, v_last_riskscore, v_license,
            v_md5, v_name, v_parent_component_id, v_purl, v_license_id, v_sha1, v_sha_256,
            v_sha3_256, v_sha3_512, v_sha_512, v_uuid, v_version, v_project_id;

        IF v_done THEN
            LEAVE component_loop;
        END IF;

        IF v_parent_component_id IS NOT NULL THEN
            SET v_parent_component_id = (SELECT `NEW_COMPONENT_ID`
                FROM `TMP_COMPONENT_MAPPING`
                WHERE `ORIGINAL_COMPONENT_ID` = v_parent_component_id
                    AND `PROJECT_ID` = v_project_id);
        END IF;

        SELECT COUNT(*) INTO v_query_count FROM `COMPONENT_40` WHERE `ID` = v_original_id;

        IF v_query_count = 0 THEN
            INSERT INTO COMPONENT_40 (`ID`, `CLASSIFIER`, `COPYRIGHT`, `CPE`, `DESCRIPTION`, `EXTENSION`, `FILENAME`,
                                      `GROUP`, `INTERNAL`, `LAST_RISKSCORE`, `LICENSE`, `MD5`, `NAME`,
                                      `PARENT_COMPONENT_ID`, `PURL`, `LICENSE_ID`, `SHA1`, `SHA_256`,`SHA3_256`,
                                      `SHA3_512`, `SHA_512`, `UUID`, `VERSION`, `PROJECT_ID`)
            VALUES (v_original_id, v_classifier, v_copyright, v_cpe, v_description,
                    v_extension, v_filename, v_group, v_internal, v_last_riskscore, v_license,
                    v_md5, v_name, v_parent_component_id, v_purl, v_license_id, v_sha1, v_sha_256,
                    v_sha3_256, v_sha3_512, v_sha_512, v_uuid, v_version, v_project_id);

            SET v_new_id = v_original_id;
        ELSE
            -- TODO switch to cryptographically secure UUIDv4 generation if needed.
            INSERT INTO COMPONENT_40 (`CLASSIFIER`, `COPYRIGHT`, `CPE`, `DESCRIPTION`, `EXTENSION`, `FILENAME`,
                                      `GROUP`, `INTERNAL`, `LAST_RISKSCORE`, `LICENSE`, `MD5`, `NAME`,
                                      `PARENT_COMPONENT_ID`, `PURL`, `LICENSE_ID`, `SHA1`, `SHA_256`,`SHA3_256`,
                                      `SHA3_512`, `SHA_512`, `UUID`, `VERSION`, `PROJECT_ID`)
            VALUES (v_classifier, v_copyright, v_cpe, v_description,
                    v_extension, v_filename, v_group, v_internal, v_last_riskscore, v_license,
                    v_md5, v_name, v_parent_component_id, v_purl, v_license_id, v_sha1, v_sha_256,
                    v_sha3_256, v_sha3_512, v_sha_512, UUID(), v_version, v_project_id);

            SELECT LAST_INSERT_ID() INTO v_new_id;
        END IF;

        INSERT INTO TMP_COMPONENT_MAPPING VALUES (v_original_id, v_new_id, v_project_id);

    END LOOP;

    CLOSE component_cursor;

    SET v_done = FALSE;

    OPEN mapping_cursor;

    related_update_loop: LOOP
        FETCH mapping_cursor INTO v_original_id, v_new_id, v_project_id;

        IF v_done THEN
            LEAVE related_update_loop;
        END IF;

        UPDATE `ANALYSIS`
        SET `COMPONENT_ID` = v_new_id
        WHERE `COMPONENT_ID` = v_original_id
            AND `PROJECT_ID` = v_project_id;

        UPDATE `DEPENDENCYMETRICS`
        SET `COMPONENT_ID` = v_new_id
        WHERE `COMPONENT_ID` = v_original_id
          AND `PROJECT_ID` = v_project_id;
    END LOOP;

    CLOSE mapping_cursor;

    INSERT INTO `COMPONENTS_VULNERABILITIES_40`
    SELECT tcm.`NEW_COMPONENT_ID`, cv.`VULNERABILITY_ID`
    FROM `TMP_COMPONENT_MAPPING` tcm
    JOIN `COMPONENTS_VULNERABILITIES` cv ON tcm.`ORIGINAL_COMPONENT_ID` = cv.`COMPONENT_ID`;
END$$

DELIMITER ;

CALL convert_components();

DROP PROCEDURE convert_components;

DROP TABLE `TMP_COMPONENT_MAPPING`;

DROP TABLE `COMPONENT`;

RENAME TABLE `COMPONENT_40` TO `COMPONENT`;

ALTER TABLE `COMPONENT`
    ADD CONSTRAINT `COMPONENT_FK1` FOREIGN KEY (`PARENT_COMPONENT_ID`) REFERENCES `COMPONENT` (`ID`),
    ADD CONSTRAINT `COMPONENT_FK2` FOREIGN KEY (`PROJECT_ID`) REFERENCES `PROJECT` (`ID`),
    ADD CONSTRAINT `COMPONENT_FK3` FOREIGN KEY (`LICENSE_ID`) REFERENCES `LICENSE` (`ID`);

ALTER TABLE `ANALYSIS` ADD CONSTRAINT `ANALYSIS_FK1` FOREIGN KEY (`COMPONENT_ID`) REFERENCES `COMPONENT` (`ID`);

DROP TABLE `COMPONENTS_VULNERABILITIES`;

RENAME TABLE `COMPONENTS_VULNERABILITIES_40` TO `COMPONENTS_VULNERABILITIES`;

ALTER TABLE `COMPONENTS_VULNERABILITIES`
    ADD CONSTRAINT `COMPONENTS_VULNERABILITIES_FK1` FOREIGN KEY (`COMPONENT_ID`) REFERENCES `COMPONENT` (`ID`),
    ADD CONSTRAINT `COMPONENTS_VULNERABILITIES_FK2` FOREIGN KEY (`VULNERABILITY_ID`) REFERENCES `VULNERABILITY` (`ID`);

ALTER TABLE `DEPENDENCYMETRICS` ADD CONSTRAINT `DEPENDENCYMETRICS_FK1` FOREIGN KEY (`COMPONENT_ID`) REFERENCES `COMPONENT` (`ID`);

ALTER TABLE `FINDINGATTRIBUTION` ADD CONSTRAINT `FINDINGATTRIBUTION_FK1` FOREIGN KEY (`COMPONENT_ID`) REFERENCES `COMPONENT` (`ID`);

ALTER TABLE `POLICYVIOLATION` ADD CONSTRAINT `POLICYVIOLATION_FK1` FOREIGN KEY (`COMPONENT_ID`) REFERENCES `COMPONENT` (`ID`);

ALTER TABLE `VIOLATIONANALYSIS` ADD CONSTRAINT `VIOLATIONANALYSIS_FK1` FOREIGN KEY (`COMPONENT_ID`) REFERENCES `COMPONENT` (`ID`);

DROP TABLE `DEPENDENCY`;
