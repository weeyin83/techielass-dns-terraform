resource "azurerm_resource_group" "dns_resource_group_name" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_dns_zone" "dns-zone" {
  name                = "techielass.com"
  resource_group_name = azurerm_resource_group.dns_resource_group_name.name
  tags = {
    environment      = var.tag_environment
    environment_name = var.tag_environment_name
  }
}

##
## M365 DNS Records
##
resource "azurerm_dns_mx_record" "M365_email_record" {
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  record {
    exchange   = "techielass-com.mail.protection.outlook.com"
    preference = 0
  }
  ttl = var.ttl
}

resource "azurerm_dns_cname_record" "M365_sip_record" {
  name                = "sip"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "sipdir.online.lync.com"
}

resource "azurerm_dns_cname_record" "M365_authentication" {
  name                = "msoid"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "clientconfig.microsoftonline-p.net"
}

resource "azurerm_dns_srv_record" "SIP_record_1" {
  name                = "_sipfederationtls._tcp.techielass.com"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  record {
    priority = 100
    weight   = 1
    port     = 5061
    target   = "sipfed.online.lync.com"
  }
  ttl = var.ttl
}

resource "azurerm_dns_srv_record" "SIP_record_2" {
  name                = "_sip._tls.techielass.com"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  record {
    priority = 100
    weight   = 1
    port     = 443
    target   = "sipdir.online.lync.com"
  }
  ttl = var.ttl
}


resource "azurerm_dns_cname_record" "M365_auto_discover_record" {
  name                = "autodiscover"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "autodiscover.outlook.com"
}

resource "azurerm_dns_cname_record" "M365_enterpriseenrollment_1" {
  name                = "enterpriseenrollment"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "enterpriseenrollment.manage.microsoft.com"
}

resource "azurerm_dns_cname_record" "M365_enterpriseenrollment_2" {
  name                = "enterpriseregistration"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "enterpriseregistration.windows.net"
}

resource "azurerm_dns_cname_record" "M365_lync" {
  name                = "lyncdiscover"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "webdir.online.lync.com"
}

##
## DMARC
##
resource "azurerm_dns_txt_record" "ghost_email" {
  name                = "_dmarc"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  record {
    value = "v=DMARC1"
  }
  ttl = var.ttl
}

resource "azurerm_dns_cname_record" "DKIM1" {
  name                = "selector1._domainkey.techielass.com"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "selector1-techielass-com._domainkey.sarahlean.onmicrosoft.com"

}

resource "azurerm_dns_cname_record" "DKIM2" {
  name                = "selector2._domainkey.techielass.com"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "selector2-techielass-com._domainkey.sarahlean.onmicrosoft.com"

}


resource "azurerm_dns_txt_record" "M365_SPF" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  record {
    value = "v=spf1  include:spf.protection.outlook.com include:mailgun.org -all"
  }
  ttl = var.ttl
}

##
## Ghost sending email record information
##

resource "azurerm_dns_txt_record" "ghost_email_2" {
  name                = "mx._domainkey.ghost"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  record {
    value = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCwYq1ctS5zlJJpyAWtAVSI6P3wXdI0UGSUOjW6BGvqVdskc0S69TSTioRuhFEBgOphICnJUYNZnV6C5ClL5p3VyZCeQEyEB2HPURjbGBv+LUbymOmdw9csa4x2+bbdPzoPr/jJA/7EsNSuU6r3+bb0yMIzitYcguO13yipFhuf9QIDAQAB"
  }
  ttl = var.ttl
}

resource "azurerm_dns_cname_record" "ghost_email_3" {
  name                = "ghost"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "ghostpro.email"
}

resource "azurerm_dns_cname_record" "ghost_email_4" {
  name                = "email.ghost"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "mailgun.org"
}

##
## Blog DNS record
##
resource "azurerm_dns_cname_record" "blog_dns" {
  name                = "www"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "techielass.ghost.io"
}

resource "azurerm_dns_a_record" "blog_dns" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = ["178.128.137.126"]
}

##
## Google Postmaster verify record
##
resource "azurerm_dns_cname_record" "google_postmaster_record" {
  name                = "jhpxokyev6t6"
  zone_name           = azurerm_dns_zone.dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  record              = "gv-qenia4qg7lssxj.dv.googlehosted.com"
}

