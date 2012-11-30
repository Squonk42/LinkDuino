#!/bin/sh
#set -xv
[ $# -ne 2 ] && echo "usage: $0 <arduino_dir> <linkduino_dir>" && exit 1
in=$1/hardware/arduino
out=$2/base-files/usr/share/arduino/hardware/arduino
sed -e '/^$/d' \
    -e '/^#/d' \
    -e 's/\.name/.board.name/g' \
    -e 's/^\(.*\)\.\(.*\)\.\(.*\)=\(.*\)/\2 \1 \3 "\4"/g' \
    "$in/boards.txt" > /tmp/boards1.txt
sed -e '/^$/d' \
    -e '/^#/d' \
    -e 's/^\(.*\)\.\(.*\)=\(.*\)/\1 \2 "\3"/g' \
    "$in/programmers.txt" > /tmp/programmers1.txt
rm -rf "$out"
mkdir -p "$out/boards" "$out/programmers" "$out/bootloaders" "$out/firmwares"
echo "config boards 'boards'" > "$out/arduino"
while read line
do
    set $line
    section=$1
    shift
    board=$1
    shift
    option=$1
    shift
    value=$*
    if [ "$section" = "board" ]
    then
        echo -e "\tlist id '$board'\n\tlist name $value" | tr '"' "'" >> "$out/arduino"
    fi
done < /tmp/boards1.txt
echo -e "\nconfig programmers 'programmers'" >> "$out/arduino"
while read line
do
    set $line
    programmer=$1
    shift
    option=$1
    shift
    value=$*
    if [ "$option" = "name" ]
    then
        echo -e "\tlist id '$programmer'\n\tlist name $value" | tr '"' "'" >> "$out/arduino"
    fi
done < /tmp/programmers1.txt
previous_board=
previous_section=
while read line
do
    set $line
    section=$1
    shift
    board=$1
    shift
    option=$1
    shift
    value=$*
    if [ "$board" = "$previous_board" ]
    then
        if [ "$section" != "$previous_section" ]
        then
            previous_section=$section
            echo -e "\nconfig $section '$section'" >> "$out/boards/$board"
        fi
        echo -e "\toption $option $value" | tr '"' "'" >> "$out/boards/$board"
    else
        previous_board=$board
    fi
done < /tmp/boards1.txt
previous_programmer=
previous_section=
while read line
do
    set $line
    programmer=$1
    shift
    option=$1
    shift
    value=$*
    if [ "$programmer" = "$previous_programmer" ]
    then
        echo -e "\toption $option $value" | tr '"' "'" >> "$out/programmers/$programmer"
    else
        previous_programmer=$programmer
        echo "config programmer 'programmer'" >> "$out/programmers/$programmer"
    fi
done < /tmp/programmers1.txt
rm -f /tmp/boards1.txt /tmp/programmers1.txt
find "$in/bootloaders" -name '*.hex' -exec bash -c "cp \"{}\" \"$out/bootloaders/\"\`basename {}\`" \;
find "$in/firmwares" -name '*.hex' -exec bash -c "cp \"{}\" \"$out/firmwares/\"\`basename {}\`" \;
