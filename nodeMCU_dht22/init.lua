-- SSID ve PASS (şifre)nizi girin
-- VE
--
print("Wifi Ayarlanıyor")
wifi.setmode(wifi.STATION)
wifi.sta.config("SSID","PASS")
wifi.sta.connect();
print("Hazır")
print(wifi.sta.getip())

pin = 4 -- GPIO2 

function getTemp()
status,temp,humi,temp_decimial,humi_decimial = dht.readxx(pin)
if( status == dht.OK ) then
  -- Integer firmware using this example
  print(     
    string.format(
      "DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
      math.floor(temp),
      temp_decimial,
      math.floor(humi),
      humi_decimial
    )
      

 
  )
  
 -- 
end
end

function sendData()
getTemp();
-- conection to thingspeak.com
print("Sending data to thingspeak.com")
conn=net.createConnection(net.TCP, 0) 
conn:on("receive", function(conn, payload) print(payload) end)
-- api.thingspeak.com 184.106.153.149
conn:connect(80,'184.106.153.149') 
conn:send("GET /update?key=XXXXXXXXXXXX&field1="..temp.."."..temp_decimial.."&field2="..humi.."."..humi_decimial.." HTTP/1.1\r\n") 
conn:send("Host: api.thingspeak.com\r\n") 
conn:send("Accept: */*\r\n") 
conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
conn:send("\r\n")
conn:on("sent",function(conn)
                      print("Closing connection")
                      conn:close()
                  end)
conn:on("disconnection", function(conn)
                      print("Got disconnection...")
  end)
end
--sendData();
-- send data every X ms to thing speak
tmr.alarm(2, 60000, 1, function() sendData() end )
