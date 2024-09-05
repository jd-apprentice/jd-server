// Usage: k6 cloud run performance/k6.js --env PROJECT_ID=<project-id> --env TARGET_URL=<target-url>
// https://grafana.com/docs/k6/latest/using-k6/environment-variables/

import http from 'k6/http';
import { check, sleep } from 'k6';

export default function() {
 const url = __ENV.TARGET_URL || "https://noticias.jonathan.com.ar/api/infobae";

  let response = http.get(url);
  check(response, {
    'is status 200': (r) => r.status === 200,
  });
  sleep(1);
}