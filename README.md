<a href="https://www.buymeacoffee.com/davesc63" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
<p>If this helps you save a few bucks, please consider buying me a beer :)

# Introduction
iOS 17 brought some challenges with allowing us to simulate the location on iOS devices.
The folks behind pymobiledevice3 have provided a way to workaround the new limitations.

This script is to make the steps more accessible to everyone! :)

This script is focused on accessing the best fuel prices across Australia

With thanks to Master131 for https://projectzerothree.info/ and https://github.com/master131/iFakeLocation/

# Caveats
- This is only for MacOS!
- "It works on my machine" - best efforts are made to be system agnostic
- sudo / root is required for pymobiledevice3 to run some of the elevated com

I would recommend running all of this in a python `virtualenv`, but that is out of scope of this script as this has been an attempt to provide a "one size fits all" approach

# Prerequisite - python
If you already have python installed, yay! If not please install python. A suggestion is to use [homebrew](https://docs.brew.sh/Installation)

Install python using `homebrew`:

```shell
brew install python
```

# Prerequisite - pymobiledeveice3

Source: https://github.com/doronz88/pymobiledevice3/tree/master

Install pymobiledevice3 using `pip`:

```shell
python3 -m pip install -U pymobiledevice3
```
# Installation
1. Download fuel-spoof.sh


2. Make it executable:
```shell
chmod +X fuel-spoof.sh
```

3. Connected your iOS17 device to your Mac

4. Execute the script
```shell
./fuel-spoof.sh
```
# Demo
<img src = "https://github.com/davesc63/fuel-spoof/blob/main/fuel-spoof.gif?raw=true">
