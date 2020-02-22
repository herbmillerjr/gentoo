# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=331
ACCT_USER_GROUPS=( ossec )
DESCRIPTION="net-analyzer/ossec-hids (csyslogd, maild)"

acct-user_add_deps
