const assert = require("node:assert/strict");
const { after, before, test } = require("node:test");

process.env.ENABLE_ACCOUNT_ROUTES = "false";

const { app, accountRoutesEnabled } = require("../src/index");

let baseUrl;
let server;

before(async () => {
  server = app.listen(0, "127.0.0.1");
  await new Promise((resolve) => server.once("listening", resolve));
  const { port } = server.address();
  baseUrl = `http://127.0.0.1:${port}`;
});

after(async () => {
  await new Promise((resolve, reject) => {
    server.close((error) => (error ? reject(error) : resolve()));
  });
});

test("keeps account routes disabled unless explicitly enabled", async () => {
  assert.equal(accountRoutesEnabled, false);

  const response = await fetch(`${baseUrl}/api/users/register`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      emplid: "12345678",
      email: "synthetic@login.cuny.edu",
      first_name: "Synthetic",
      last_name: "Student",
      password: "not-a-real-password",
    }),
  });

  assert.equal(response.status, 404);
  assert.deepEqual(await response.json(), { error: "Not found" });
});

test("keeps existing account profiles inaccessible", async () => {
  const response = await fetch(`${baseUrl}/api/users/profile`);

  assert.equal(response.status, 404);
  assert.deepEqual(await response.json(), { error: "Not found" });
});
