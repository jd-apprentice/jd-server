// Usage: k6 cloud run performance/api-waifuland.js  --env TARGET_URL=<target-url>
// https://grafana.com/docs/k6/latest/using-k6/environment-variables/

import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: __ENV.VUS || 5,
  duration: __ENV.DURATION || '60s',
  thresholds: {
    http_req_duration: ['p(95)<5000'], // 95% of requests must complete below 5 seconds
    http_req_failed: ['rate<0.1'], // http errors should be less than 10%
  },
};

/**
 * @usage k6 cloud run performance/api-waifuland.js --env TARGET_URL=<target-url>
 * @environment VUS (default: 5)
 * @environment TARGET_URL (default: ...)
 * @environment DURATION (default: 60s)
 * @description K6 performance test
 */
export default function () {
  const url = __ENV.TARGET_URL || "https://waifuland.jonathan.com.ar/api/images";

  let response = http.get(url);
  check(response, {
    'is status 200': (r) => r.status === 200,
  });
  sleep(1);
};
