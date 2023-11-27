import requests
import time
import json

# addr = "http://192.168.4.1/wheel/speed"
addr = "http://192.168.4.1/sensor/temp"

succ_num = 0
start_time = time.time()
# distance = 1
for i in range(100):
    response = None
    try:
        response = requests.post(addr, data="50", timeout=(0.8, None))
    except:
        pass

    if response != None and response.status_code == 200:
        succ_num += 1
print(succ_num)
consume_time = time.time() - start_time
print(consume_time)

file_path = "./test_result.json"
with open(file_path, "r") as f:
    content_str = f.read()
    content_list: list = json.loads(content_str)

distance = content_list[-1]["distance"] + 1
print(distance)
result = {"distance": distance, "succ_num": succ_num, "time": consume_time}
content_list.append(result)
with open(file_path, "w") as f:
    f.write(json.dumps(content_list))
print(content_list)
