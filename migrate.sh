#!/bin/bash
# Copyright © 2011 Perberos
# Original version fetched from:
# https://github.com/perberos/Mate-Desktop-Environment/wiki/Migrating
#
# Extended by benpicco
# https://github.com/jasmineaura/mate-scripts/blob/master/migrate.sh
#
# Updated by Jasmine Hassan <jasmine.aura@gmail.com>
# https://github.com/jasmineaura/mate-scripts/blob/master/migrate.sh
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 3 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
##########
#
# If no argument is specified, script will try to look in src/, if exists.
#

if [ $# -gt 0 ]; then
  # translates symlinks and relative paths(./ ../ ../../ etc..)
  pkgdir=`readlink -f $1`
  [ "$1" != "$pkgdir" ] && echo "[*] Resolved '$1' -> '$pkgdir'"

  [ ! -e "$pkgdir" ] && printf "[!] '$pkgdir' does not exist.\nExiting!\n" && exit 1
  [ ! -d "$pkgdir" ] && printf "[!] '$pkgdir' is not a directory.\nExiting!\n" && exit 1
elif [ -d "src" ]; then
  pkgdir="`pwd`/src"
else
  echo "[!] You didn't specify a directory, and script couldn't find an 'src/' in the current directoy:"
  printf "    `pwd`\nExiting!\n" && exit 1
fi


# Readonly array. Runtime modification attempt must throw error.
readonly -a  \
replaces=(
	'ior-decode-2' 'matecorba-ior-decode-2'
	'linc-cleanup-sockets' 'matecorba-linc-cleanup-sockets'
	'typelib-dump' 'matecorba-typelib-dump'
	'libname-server-2' 'libname-matecorba-server-2'

	'panel-applet' 'mate-panel-applet'
	'panelapplet' 'matepanelapplet'
	'panel_applet' 'mate_panel_applet'
	'PANEL_APPLET' 'MATE_PANEL_APPLET'
	'PanelApplet' 'MatePanelApplet'

	'mate-mate-panel-applet' 'mate-panel-applet'
	'matematepanelapplet' 'matepanelapplet'
	'mate_mate_panel_applet' 'mate_panel_applet'
	'MATE_MATE_PANEL_APPLET' 'MATE_PANEL_APPLET'
	'MateMatePanelApplet' 'MatePanelApplet'

	'gnome' 'mate'
	'GNOME' 'MATE'
	'Gnome' 'Mate'

#includes

	'<gconf\/gconf-' '<mateconf\/mateconf\/2\/mateconf\/mateconf-'

#	srsly?
#	'gsd' 'msd'

	'Metacity' 'Marco'
	'metacity' 'marco'
	'METACITY' 'MARCO'

	'Nautilus' 'Caja'
	'nautilus' 'caja'
	'NAUTILUS' 'CAJA'

	'Zenity' 'MateDialog'
	'zenity' 'matedialog'
	'ZENITY' 'MATEDIALOG'

	'MATE|Utilities' 'GNOME|Utilities'
	'MATE|Desktop' 'GNOME|Desktop'
	'MATE|Applets' 'GNOME|Applets'
	'MATE|Applications' 'GNOME|Applications'
	'MATE|Multimedia' 'GNOME|Multimedia'

	'mate.org' 'gnome.org'
	'mate.gr.jp' 'gnome.gr.jp'

	'libnotify' 'libmatenotify'
	'LIBNOTIFY' 'LIBMATENOTIFY'
	'Libnotify' 'Libmatenotify'

	'bonobo' 'matecomponent'
	'Bonobo' 'MateComponent'
	'BONOBO' 'MATECOMPONENT'
	'bonoboui' 'matecomponentui'
	'BONOBOUI' 'MATECOMPONENTUI'

	'gconf' 'mateconf'
	'GConf' 'MateConf'
	'GCONF' 'MATECONF'

	'pkmateconfig' 'pkgconfig'
	'PKMATECONFIG' 'PKGCONFIG'

	'gweather' 'mateweather'
	'GWeather' 'MateWeather'
	'GWEATHER' 'MATEWEATHER'

	'ORBit' 'MateCORBA'
	'orbit' 'matecorba'
	'ORBIT' 'MATECORBA'

	'panel-applet' 'mate-panel-applet'
	'panelapplet' 'matepanelapplet'
	'panel_applet' 'mate_panel_applet'
	'PANEL_APPLET' 'MATE_PANEL_APPLET'
	'PanelApplet' 'MatePanelApplet'

	# mistakes
	'mate-mate-panel-applet' 'mate-panel-applet'
	'matematepanelapplet' 'matepanelapplet'
	'mate_mate_panel_applet' 'mate_panel_applet'
	'MATE_MATE_PANEL_APPLET' 'MATE_PANEL_APPLET'
	'MateMatePanelApplet' 'MatePanelApplet'

	'soup-mate' 'soup-gnome'
	'SOUP_TYPE_MATE_FEATURES_2_26' 'SOUP_TYPE_GNOME_FEATURES_2_26'
	'mateconfaudiosink' 'gconfaudiosink'
	'mateconfvideosink' 'gconfvideosink'

	'TAMATECONFIG' 'TAGCONFIG'

	# GNOME Keyboard
	'gkbd' 'matekbd'
	'Gkbd' 'Matekbd'
	'GKBD' 'MATEKBD'


	# GMenu
	'GMenu' 'MateMenu'
	'gmenu' 'matemenu'
	'GMENU' 'MATEMENU'

	'alacarte' 'mozo'
	'Alacarte' 'Mozo'
	'ALACARTE' 'MOZO'

	# polkit
	'polkitgtk' 'polkitgtkmate'
	'polkit-gtk' 'polkit-gtk-mate'
	'PolkitGtk' 'PolkitGtkMate'
	'POLKITGTK' 'POLKITGTKMATE'
	'POLKIT_GTK' 'POLKIT_GTK_MATE'
	'polkit_gtk' 'polkit_gtk_mate'

	'polkit_gtk_mate_mate' 'polkit_gtk_mate'
	'polkitgtkmatemate' 'polkitgtkmate'
	'PolkitGtkMateMate' 'PolkitGtkMate'
	'POLKITGTKMATEMATE' 'POLKITGTKMATE'
	'POLKIT_GTK_MATE_MATE' 'POLKIT_GTK_MATE'
	'polkit-gtk-mate-mate' 'polkit-gtk-mate'

	# GDM
	'gdm' 'mdm'
	'Gdm' 'Mdm'
	'GDM' 'MDM'


	# Glib Deprecated
	'G_CONST_RETURN' 'const'

	# Eye of GNOME
	'eog' 'eom' # only on the exe generated name

	# gedit
	'gedit' 'pluma'
	'GEDIT' 'PLUMA'
	'Gedit' 'Pluma'


	# evince
	'EVINCE' 'ATRIL'
	'evince' 'atril'
	'Evince' 'Atril'
)



MV_ACTION="Renaming:  "

if [ "x$RENAME" != "x1" ]; then
	echo "[-] Renaming files/dirs *disabled* by default. Script only prints what needs renaming."
  echo -e "    For auto-renaming, run again with RENAME=1:\n    \$ RENAME=1 $0 $@"
  MV_ACTION="Skipping:   "
fi


FILES=($(find "$pkgdir/" -type f -not \( -ipath '*.git*' -o -iname "changeLog*" -o -name INSTALL \
  -o -name NEWS -o -name AUTHORS -o -name COPYING* -o -name TODO -o -iname copyright \
  -o -name config.sub -o -name config.guess -o -name config.status -o -name config.log \) -printf '%P\n'))
echo "[*] Analyzing ${#FILES[@]} files..."

#
# patch files
#

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

# We should back up IFS before messing with it (difficult to set in shell)
origIFS=$IFS
#InternalFieldSeperator. Only use newlines as seperator?
IFS=$'\n'
text=$(for key in $(seq 0 2 $((${#replaces[@]} - 1))); do echo ${replaces[$key]}; done)

############# TODO http://stackoverflow.com/questions/9066609/fastest-possible-grep ##############

for F in ${FILES[@]}; do
  {
    [[ -n $(grep -F "$text" "$pkgdir/$F") ]] || continue
		fprocess="Processing: '$F'" && col=$((`tput cols`-${#fprocess})) && echo -n $fprocess
		for key in $(seq 0 2 $((${#replaces[@]} - 1))); do
		  [[ -n $(grep -F "${replaces[$key]}" "$pkgdir/$F") ]] || continue
			sed -i "s/${replaces[$key]}/${replaces[$key + 1]}/g" "$pkgdir/$F" || echo "${replaces[$key]} -> ${replaces[$key + 1]}"
			# datacontent=${datacontent/${replaces[$key]}/${replaces[$key + 1]}}
		done
		printf '%s%*s%s' "$GREEN" "$col" "[DONE]" "$NORMAL"
	} & 
	wait $!
done
IFS=$origIFS


#
# Analyze/rename dirs
#

# We need to rename directories in reverse order (higher levels first)
# Do we have the awesome "tac"? (reverse cat, from coreutils pkg)
if [ -x /usr/bin/tac ]; then
  echo "[+] Got 'tac' :>"
  DIRS=($(find "$pkgdir/" -type d -not -ipath '*.git*' -printf '%P\n' | grep -v "^$" | tac))
else
  DIRS=($(find "$pkgdir/" -type d -not -ipath '*.git*' -printf '%P\n' | grep -v "^$"))
  for ((i=${#DIRS[@]}-1; i>=0; i--)); do
    DIRS=("${DIRS[@]}" ${DIRS[i]}) && unset DIRS[i]
  done
fi
echo "[*] Checking ${#DIRS[@]} directory names..."

for dir in ${DIRS[@]}; do
  path=$(dirname "$pkgdir/$dir")
  oldname=$(basename "$dir")
  newname=$oldname
  for key in $(seq 0 2 $((${#replaces[@]} - 1))); do
    [[ "$newname" == *"${replaces[$key]}"* ]] && \
    newname=${newname/${replaces[$key]}/${replaces[$key + 1]}}
  done

  if [ "$newname" != "$oldname" ]; then
    echo -e "$MV_ACTION mv $path/$oldname\t$path/$newname"
    [ "x$RENAME" = "x1" ] && mv "$path/$oldname" "$path/$newname"
  fi
done


#
# Check/rename files
#
echo "[*] Checking ${#FILES[@]} filenames..."

for file in ${FILES[@]}; do
  path=$(dirname "$pkgdir/$file")
  oldname=$(basename "$file")
  newname=$oldname
  for key in $(seq 0 2 $((${#replaces[@]} - 1))); do
    [[ "$newname" == *"${replaces[$key]}"* ]] && \
    newname=${newname/${replaces[$key]}/${replaces[$key + 1]}}
  done

  if [ "$newname" != "$oldname" ]; then
    echo -e "$MV_ACTION mv $path/$oldname\t$path/$newname"
    [ "x$RENAME" = "x1" ] && mv "$path/$oldname" "$path/$newname"
  fi
done


echo "All operations completed, mate. ;)"
