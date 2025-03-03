import http from "k6/http";
import { check, sleep } from "k6";
import { randomIntBetween } from "https://jslib.k6.io/k6-utils/1.2.0/index.js";

const BASE_URL = "http://localhost:3000/api/v1";
const LOGIN_URL = `${BASE_URL}/login`;
const SLEEP_HISTORY_URL = `${BASE_URL}/user/following/sleep_histories`;

export const options = {
  vus: 100,
  duration: "1m",
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
  let userID = randomIntBetween(1, 5);
  let token = login(userID);

  let params = {
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
      Authorization: `Bearer ${token}`,
    },
  };

  let history_path = `${SLEEP_HISTORY_URL}?page=${randomIntBetween(1, 9)}`;
  let res = http.get(history_path, params);
  check(res, { "status is 200": (res) => res.status === 200 });
  sleep(1);
}
