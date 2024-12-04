<?php
/**
 * Custom phpMyAdmin configuration for Innovation Network Manager
 */

// Server configuration
$cfg['Servers'][1]['host'] = 'db';
$cfg['Servers'][1]['port'] = '3306';
$cfg['Servers'][1]['user'] = 'innovation_user';
$cfg['Servers'][1]['password'] = getenv('DB_PASSWORD');
$cfg['Servers'][1]['auth_type'] = 'config';
$cfg['Servers'][1]['AllowNoPassword'] = false;
$cfg['Servers'][1]['AllowRoot'] = false;
$cfg['Servers'][1]['compress'] = false;
$cfg['Servers'][1]['controluser'] = 'innovation_user';
$cfg['Servers'][1]['controlpass'] = getenv('DB_PASSWORD');

// Database display settings
$cfg['ShowDatabasesNavigationAsTree'] = true;
$cfg['NavigationTreeEnableGrouping'] = true;
$cfg['MaxNavigationItems'] = 250;
$cfg['NavigationTreeDisplayItemFilterMinimum'] = 30;
$cfg['NavigationTreeDisplayDbFilterMinimum'] = 30;

// Interface settings
$cfg['RememberSorting'] = true;
$cfg['ShowBrowseComments'] = true;
$cfg['ShowPropertyComments'] = true;
$cfg['QueryHistoryMax'] = 100;
$cfg['RetainQueryBox'] = true;
$cfg['CodemirrorEnable'] = true;
$cfg['DefaultLang'] = 'es';
$cfg['DefaultConnectionCollation'] = 'utf8mb4_unicode_ci';

// Export/Import settings
$cfg['Export']['method'] = 'custom';
$cfg['Import']['charset'] = 'utf8';
$cfg['Export']['charset'] = 'utf8';
$cfg['Export']['compression'] = 'gzip';
$cfg['ZipDump'] = true;
$cfg['GZipDump'] = true;

// Console settings
$cfg['ConsoleEnterExecutes'] = true;
$cfg['Console']['DarkTheme'] = false;

// Security settings
$cfg['CheckConfigurationPermissions'] = false;
$cfg['AllowUserDropDatabase'] = false;
$cfg['AllowArbitraryServer'] = false;
$cfg['LoginCookieValidity'] = 1440;
$cfg['LoginCookieStore'] = 0;
$cfg['LoginCookieDeleteAll'] = true;
$cfg['VersionCheck'] = false;

// Theme settings
$cfg['ThemeDefault'] = 'pmahomme';
$cfg['ThemeManager'] = true;

// Other settings
$cfg['MaxRows'] = 100;
$cfg['SendErrorReports'] = 'never';
$cfg['ShowTooltip'] = true;
$cfg['RowActionLinks'] = 'both';