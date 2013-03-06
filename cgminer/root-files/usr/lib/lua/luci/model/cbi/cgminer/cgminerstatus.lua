--[[
LuCI - Lua Configuration Interface

Copyright 2013 Xiangfu
Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--
f = SimpleForm("cgminerstatus", translate("Cgminer Status"), translate("This list gives an overview over currently running cgminer."))
f.reset = false
f.submit = false

t = f:section(Table, luci.controller.cgminer.summary(), translate("Summary"))
t:option(DummyValue, "elapsed", translate("Elapsed"))
t:option(DummyValue, "mhsav", translate("MHSav"))
t:option(DummyValue, "foundblocks", translate("FoundBlocks"))
t:option(DummyValue, "getworks", translate("Getworks"))
t:option(DummyValue, "accepted", translate("Accepted"))
t:option(DummyValue, "rejected", translate("Rejected"))
t:option(DummyValue, "hw", translate("HW"))
t:option(DummyValue, "utility", translate("Utility"))
t:option(DummyValue, "discarded", translate("Discarded"))
t:option(DummyValue, "stale", translate("Stale"))
t:option(DummyValue, "getfailures", translate("GetFailures"))
t:option(DummyValue, "localwork", translate("LocalWork"))
t:option(DummyValue, "remotefailures", translate("RemoteFailures"))
t:option(DummyValue, "networkblocks", translate("NetworkBlocks"))
t:option(DummyValue, "totalmh", translate("TotalMH"))
t:option(DummyValue, "wu", translate("WU"))
t:option(DummyValue, "diffaccepted", translate("DiffA"))
t:option(DummyValue, "diffrejected", translate("DiffR"))
t:option(DummyValue, "diffstale", translate("DiffS"))
t:option(DummyValue, "bestshare", translate("BestShare"))

t2 = f:section(Table, luci.controller.cgminer.pools(), translate("Pools"))
t2:option(DummyValue, "pool", translate("Pool"))
t2:option(DummyValue, "url", translate("URL"))
t2:option(DummyValue, "status", translate("Status"))
t2:option(DummyValue, "priority", translate("Priority"))
t2:option(DummyValue, "longpoll", translate("LP"))
t2:option(DummyValue, "getworks", translate("GetWorks"))
t2:option(DummyValue, "accepted", translate("Accepted"))
t2:option(DummyValue, "rejected", translate("Rejected"))
t2:option(DummyValue, "discarded", translate("Discarded"))
t2:option(DummyValue, "stale", translate("Stale"))
t2:option(DummyValue, "getfailures", translate("GF"))
t2:option(DummyValue, "remotefailures", translate("RF"))
t2:option(DummyValue, "user", translate("User"))
t2:option(DummyValue, "lastsharetime", translate("LastShareTime"))
t2:option(DummyValue, "diff1shares", translate("Diff1Shares"))
t2:option(DummyValue, "diffaccepted", translate("DiffA"))
t2:option(DummyValue, "diffrejected", translate("DiffR"))
t2:option(DummyValue, "diffstale", translate("DiffS"))
t2:option(DummyValue, "lastsharedifficulty", translate("LSD"))
t2:option(DummyValue, "hasstratum", translate("HasStratum"))
t2:option(DummyValue, "stratumactive", translate("StratumActive"))
t2:option(DummyValue, "stratumurl", translate("StratumURL"))
t2:option(DummyValue, "hasgbt", translate("GBT"))

return f
