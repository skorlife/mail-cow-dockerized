if printf "%s\n" "${SKIP_SOGO}" | grep -E '^([yY][eE][sS]|[yY])+$' >/dev/null; then
  echo "return 410;"
elif [[ ! -z "${SOGO_IPv4}" ]]; then
  echo "proxy_pass http://${SOGO_IPv4}:20000/SOGo/Microsoft-Server-ActiveSync;"
else
  echo "proxy_pass http://${IPV4_NETWORK}.248:20000/SOGo/Microsoft-Server-ActiveSync;"
fi
