%define		plugin	check_domain
Summary:	Nagios pluging for checking a domain name expiration date
Name:		nagios-plugin-%{plugin}
Version:	0.1
Release:	0.1
License:	BSD
Group:		Networking
Source0:	%{plugin}
# Source0-md5:	fe2dffc066980e2385d88755703f97fe
URL:		http://www.tomas.cat/blog/en/checking-domain-name-expiration-date-checkdomain
Requires:	whois
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%define		_sysconfdir	/etc/nagios/plugins
%define		plugindir	%{_prefix}/lib/nagios/plugins

%description
Nagios pluging for checking a domain name expiration date.

%prep
%setup -qcT
install -p %{SOURCE0} %{plugin}

cat > nagios.cfg <<'EOF'
# Usage:
# %{plugin}
define command {
	command_name    %{plugin}
	command_line    %{plugindir}/%{plugin} -w 30 -c 10 -d $ARG1$
}
EOF

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_sysconfdir},%{plugindir}}
install -p %{plugin} $RPM_BUILD_ROOT%{plugindir}/%{plugin}
cp -a nagios.cfg $RPM_BUILD_ROOT%{_sysconfdir}/%{plugin}.cfg

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%config(noreplace) %verify(not md5 mtime size) %{_sysconfdir}/%{plugin}.cfg
%attr(755,root,root) %{plugindir}/%{plugin}
