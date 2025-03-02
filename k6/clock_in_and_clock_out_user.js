import http from "k6/http";
import { check, sleep } from "k6";
import { randomIntBetween } from "https://jslib.k6.io/k6-utils/1.2.0/index.js";

const BASE_URL = "http://localhost:3000/api/v1";
const LOGIN_URL = `${BASE_URL}/login`;
const CLOCK_IN = `${BASE_URL}/user/clock_in`;
const CLOCK_OUT = `${BASE_URL}/user/clock_out`;

export const options = {
  vus: 100,
  duration: "60s",
};

function login(userID) {
  const payload = JSON.stringify({
    name: `User${userID}`,
    password: "password",
  });

  let params = {
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
  };

  let res = http.post(LOGIN_URL, payload, params);
  check(res, {
    "login success": (r) => r.status === 200,
  });

  let token = res.json("token");
  return token;
}

export default function () {
  let userID = randomIntBetween(1, 1000);
  let token = login(userID);

  let params = {
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
      Authorization: `Bearer ${token}`,
    },
  };

  let clockInRes = http.post(CLOCK_IN, null, params);
  check(clockInRes, { "clock in success": (res) => res.status === 200 });
  sleep(2);

  let clockOutRes = http.patch(CLOCK_OUT, null, params);
  check(clockOutRes, { "clock out success": (res) => res.status === 200 });
  sleep(1);
}
