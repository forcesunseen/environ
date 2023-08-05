fs = require('fs');
const { exec } = require('child_process');

console.log('_SECRET_TEST=' + process.env._SECRET_TEST);
delete process.env._SECRET_TEST;
console.log('_SECRET_TEST=' + process.env._SECRET_TEST);

let data = fs.readFileSync('/proc/self/environ', 'utf8');
for (let i in data.split('\0')) {
	d = data.split('\0')[i];
	if (d.startsWith('_SECRET_TEST')) {
		ok = true;
		console.log(d);
	};
}
if (!ok) {
	// no variable found
	console.log('_SECRET_TEST=');
}

exec("bash -c 'echo _SECRET_TEST=${_SECRET_TEST}'", (error, stdout, stderr) => {
	if (error) {
		console.log(error);
		process.exit(1);
	}
	console.log(`${stdout}`);
});
