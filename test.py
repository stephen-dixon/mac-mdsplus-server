from mdsthin import Connection

c = Connection("localhost:8000")
c.openTree("test", 1)

print(c.get(":IP").data())
print(c.get("dim_of(:IP)").data())

print(c.get(":DENSITY").data())
print(c.get("dim_of(:DENSITY)").data())
