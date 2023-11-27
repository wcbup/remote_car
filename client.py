import requests


class Menu:
    def __init__(self, address="http://192.168.4.1") -> None:
        self.address = address

    def stop(self) -> requests.Response:
        response = requests.post(self.address + "/wheel/stop")
        return response

    def set_speed(self, speed: int) -> requests.Response:
        response = requests.post(
            self.address + "/wheel/speed",
            data=speed,
        )
        return response

    def forward(self) -> requests.Response:
        response = requests.post(self.address + "/wheel/forward")
        return response

    def back(self) -> requests.Response:
        response = requests.post(self.address + "/wheel/back")
        return response

    def left(self) -> requests.Response:
        response = requests.post(self.address + "/wheel/left")
        return response

    def right(self) -> requests.Response:
        response = requests.post(self.address + "/wheel/right")
        return response

    def get_humid_temp(self) -> requests.Response:
        response = requests.post(self.address + "/sensor/temp")
        return response

    def start_loop(self) -> None:
        while True:
            print("---please choose command---")
            print("1. get humidity and temperature")
            print("2. set speed")
            print("3. stop")
            print("4. go forward")
            print("5. go back")
            print("6. turn left")
            print("7. turn right")
            print("8. quit")
            command = int(input("Please input one integer:"))
            while not (isinstance(command, int) and command >= 1 and command <= 8):
                print("Error input, please try again!")
                command = int(input("please input one integer:"))

            match command:
                case 1:
                    response = self.get_humid_temp()
                    if response.status_code == 200:
                        # print(response.text)
                        results = response.text.split(" ")
                        print(
                            f"The humidity is {float(results[0]) / 100}. The temperature is {float(results[1])/100}"
                        )
                    else:
                        print("Command failed!")

                case 2:
                    speed = int(
                        input("Please input the speed (Range between 1 to 10):")
                    )
                    while not (isinstance(speed, int) and speed >= 1 and speed <= 10):
                        print("Error input, please try again!")
                        speed = int(
                            input("Please input the speed (Range between 1 to 10):")
                        )
                    response = self.set_speed(str(speed))
                    if response.status_code == 200:
                        print("Command success!")
                    else:
                        print("Command failed!")

                case 3:
                    response = self.stop()
                    if response.status_code == 200:
                        print("Command success!")
                    else:
                        print("Command failed!")

                case 4:
                    response = self.forward()
                    if response.status_code == 200:
                        print("Command success!")
                    else:
                        print("Command failed!")

                case 5:
                    response = self.back()
                    if response.status_code == 200:
                        print("Command success!")
                    else:
                        print("Command failed!")

                case 6:
                    response = self.left()
                    if response.status_code == 200:
                        print("Command success!")
                    else:
                        print("Command failed!")

                case 7:
                    response = self.right()
                    if response.status_code == 200:
                        print("Command success!")
                    else:
                        print("Command failed!")

                case 8:
                    break

                case _:
                    raise Exception()


# test code
if __name__ == "__main__":
    menu = Menu()
    menu.start_loop()
