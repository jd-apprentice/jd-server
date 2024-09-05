// Usage: k6 cloud run performance/api-infobae.js  --env TARGET_URL=<target-url>
// https://grafana.com/docs/k6/latest/using-k6/environment-variables/

import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: __ENV.VUS || 5,
  duration: __ENV.DURATION || '30s',
  thresholds: {
    http_req_duration: ['p(90)<10000'], // 90% of requests must complete below 10 seconds
    http_req_failed: ['rate<0.1'], // http errors should be less than 10%
  },
};

/**
 * @usage k6 cloud run performance/api-infobae.js --env TARGET_URL=<target-url>
 * @environment VUS (default: 10)
 * @environment TARGET_URL (default: ...)
 * @environment DURATION (default: 30s)
 * @description K6 performance test
 */
export default function() {
 const url = __ENV.TARGET_URL || "https://noticias.jonathan.com.ar/api/infobae";

  let response = http.get(url);
  check(response, {
    'is status 200': (r) => r.status === 200,
    'is content-type json': (r) => r.headers['content-type'] === 'application/json; charset=utf-8',
    'it contains 3 keys': (r) => Object.keys(r.json()).length === 3
  });
  sleep(1);
};
