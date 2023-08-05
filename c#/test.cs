using System;
using System.IO;

public class Test {
	static public void Main() {
		// Read the envvar
		string v = Environment.GetEnvironmentVariable("_SECRET_TEST");
		Console.WriteLine($"_SECRET_TEST={v}");
		// Unset the envvar
		Environment.SetEnvironmentVariable("_SECRET_TEST", null);
		// Re-read the envvar
		string u = Environment.GetEnvironmentVariable("_SECRET_TEST");
		Console.WriteLine($"_SECRET_TEST={u}");

		// Read the envvar from /proc/self/environ
		bool ok = true;
		using (StreamReader sr = new StreamReader(@"/proc/self/environ")) {
			while (sr.Peek() >= 0) {
				string l = sr.ReadLine();
				string[] envs = l.Split("\x00");
				for (int i = 0; i < envs.Length; i++) {
					if (envs[i].StartsWith("_SECRET_TEST")) {
						ok = true;
						Console.WriteLine($"{envs[i]}\n");
					}
				}
			}
		}
		// ...or write an empty one
		if (!ok) {
			Console.WriteLine("_SECRET_TEST=");
		}
	}
}
