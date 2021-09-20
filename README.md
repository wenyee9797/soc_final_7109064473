# SOC final project
  - using vivado 2019.1 to progam
  - all the constaint set only for zedboard
  - only use pl side to run this project
# Input/Output
  - 4 buttons on zedboard use to control the moving direction of snake
  - 1 button on middle use to reset the game
  - using zedboard VGA port for output
  - LED light as score calculation (binary) 

# Vivado Step
  - create a project
    - project type: RTL
    - add all the files
    - add the constrains file
    - select default part: zedboard zynq evaluation and development kit
  - connect board with pc/laptop via uart
  - open hardware manager and open target zedboard
  - program device
  - start gaming!
# Result
  ![alt text](https://github.com/wenyee9797/zedboard-snake-game/tree/main/picture/game.JPG)
