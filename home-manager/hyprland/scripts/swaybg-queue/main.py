import io
from os import listdir, system
from random import choice

def main():
    wallpapers = listdir('/home/dallinchi/Pictures/Wallpapers/')
    try:
        with open('/home/dallinchi/Code/Projects/swaybg-queue/queue', 'r', encoding='utf-8') as file:
            i = int(file.readline())
            if len(wallpapers) <= i:
                i = 0
            
            system('pkill swaybg')
            system(f'hyprctl dispatch exec " swaybg -i /home/dallinchi/Pictures/Wallpapers/{wallpapers[i]} -m fill"')
            print(i)
    except io.UnsupportedOperation:
        pass
    finally:
        with open('/home/dallinchi/Code/Projects/swaybg-queue/queue', 'w', encoding='utf-8') as file:
            i = int(i) + 1       
            file.write(str(i))

if __name__ == '__main__':
    main()
