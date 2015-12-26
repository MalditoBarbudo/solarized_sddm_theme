# Solarized theme for sddm

This theme is inspired by Numix sddm theme
([https://github.com/intialonso/intialonso.github.io](https://github.com/intialonso/intialonso.github.io/tree/master/themes/sddm/numix))
by Inti Alonso and the default sddm theme, maui ([https://github.com/sddm/sddm](https://github.com/sddm/sddm)). As in Numix theme, the wallpaper was generated using the tool:
[http://matthew.wagerfield.com/flat-surface-shader/](http://matthew.wagerfield.com/flat-surface-shader/)
by Matthew Wagerfield and Tobias van Schneider. It also uses some icons from
Numix icon theme
[https://github.com/numixproject/numix-icon-theme](https://github.com/numixproject/numix-icon-theme)
(shutdown, warning and down arrow icons).  
QML files contain license headers.  

## Dependencies
This theme relies in `Raleway` and `Fontawesome` fonts. If you try this, make sure
that they are installed in your system.

In arch this fonts can be installed from aur:  

- [otf-raleway](https://aur.archlinux.org/packages/otf-raleway/)  
- [ttf-font-awesome](https://aur.archlinux.org/packages/ttf-font-awesome)  
- `Raleway` also can be installed from
  [ttf-google-fonts-git](https://aur.archlinux.org/packages/ttf-google-fonts-git/)
  which also installs other cool fonts.

## Screenshot (2015-12-25)

![screenshot](solarized_sddm_theme.png)

## Aim
The aim of this theme is to display a simple yet complete sddm greeter based in
solarized palette by Ethan Schoonover
([http://ethanschoonover.com/solarized](http://ethanschoonover.com/solarized)).  
I use this colors almost everywhere so, why not in the greeter? ;)

## Known Issues

1. White arrows background in session and layout boxes (see bug #1).
   Fix is in [upstream](https://github.com/sddm/sddm), waiting for it in
   the stable version.

## License

Theme is licensed under GPL.  
QML files are MIT licensed.
