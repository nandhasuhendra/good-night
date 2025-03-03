import http from "k6/http";
import { check, sleep } from "k6";
import { Trend } from "k6/metrics";
import { randomIntBetween } from "https://jslib.k6.io/k6-utils/1.2.0/index.js";

const BASE_URL = "http://localhost:3000/api/v1";
const LOGIN_URL = `${BASE_URL}/login`;

let followTrend = new Trend("follow_request_duration");
let unfollowTrend = new Trend("unfollow_request_duration");

export let options = {
  vus: 10,
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
  let userID = randomIntBetween(1, 10);
  let targetID = randomIntBetween(1, 10);
  let token = login(userID);

  while (userID === targetID) {
    targetID = randomIntBetween(1, 10);
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
      "follow request success": (r) => {
        if (r.status !== 201) {
          console.log(r.status, r.body);
        }

        r.status === 201;
      },
    });

    check(unfollowRes, {
      "unfollow request success": (r) => {
        if (r.status !== 204) {
          console.log(r.status, r.body);
        }

        r.status === 204;
      },
    });
  });

  sleep(1);
}
