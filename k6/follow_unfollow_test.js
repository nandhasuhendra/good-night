import http from "k6/http";
import { check, sleep } from "k6";
import { Trend } from "k6/metrics";
import { randomIntBetween } from "https://jslib.k6.io/k6-utils/1.2.0/index.js";

const BASE_URL = "http://localhost:3000/api/v1";
const LOGIN_URL = `${BASE_URL}/login`;

let followTrend = new Trend("follow_request_duration");
let unfollowTrend = new Trend("unfollow_request_duration");

export let options = {
  vus: 100,
  duration: "30s",
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
    "status is 200": (r) => r.status === 200,
  });

  let token = res.json("token");
  return token;
}

export default function () {
  let userID = randomIntBetween(1, 1000);
  let targetID = randomIntBetween(1, 1000);
  let token = login(userID);

  while (userID === targetID) {
    targetID = randomIntBetween(1, 1000);
  }

  let params = {
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
      Authorization: `Bearer ${token}`,
    },
  };

  let respones = Promise.all([
    http.post(`${BASE_URL}/users/${targetID}/follow`, null, params),
    http.del(`${BASE_URL}/users/${targetID}/unfollow`, null, params),
  ]);

  respones.then(([followRes, unfollowRes]) => {
    followTrend.add(followRes.timings.duration);
    unfollowTrend.add(unfollowRes.timings.duration);

    check(followRes, {
      "follow request success": (r) => r.status === 201,
    });

    check(unfollowRes, {
      "unfollow request success": (r) => r.status === 204,
    });
  });

  sleep(1);
}
