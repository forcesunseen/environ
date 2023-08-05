puts "_SECRET_TEST=%s" % ENV["_SECRET_TEST"]
ENV::delete("_SECRET_TEST")
puts "_SECRET_TEST=%s" % ENV["_SECRET_TEST"]
f = File.open("/proc/self/environ")
d = f.read&.split("\u0000")
puts "%s" % d
e = system("echo _SECRET_TEST=${SECRET_TEST}")
