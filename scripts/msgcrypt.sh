#!/bin/bash

SIGNS=( a b c d f e h g j i l k m n o p q r s t u v w x y z A B C D F E H G J I L K M N O P Q R S T U V W X Y Z . - ? ! "#" "+" )

function query() { 
    nc=0
    while [ $nc -lt ${#SIGNS[@]} ]; do 
        if [ "$1" = "${SIGNS[$nc]}" ]; then
            local ORIGNUM=$nc
        fi
        ((nc++))
    done

    if [  -z $ORIGNUM ]; then
        echo -n "$1"
        return
    fi
    ENCRYPTNUM=$(($ORIGNUM + ${#SIGNS[@]} / 2))
    if [ $ENCRYPTNUM -ge ${#SIGNS[@]} ]; then
        ENCRYPTNUM=$(($ENCRYPTNUM - ${#SIGNS[@]} ))
    fi

    
    echo -n ${SIGNS[$ENCRYPTNUM]} 
}

function table() {
    for x in ${SIGNS[@]}; do
        echo -n "$x: "
        query $x
        echo
    done
}

function main() {
    
    if [ $# -eq 0 ]; then
        set -- "$(cat /dev/stdin)"
    fi
    local sc=0
    while [ $sc -lt ${#1} ]; do
        if [ "${1:$sc:1}" = " " ]; then 
            echo -n " "
        else
            query "${1:$sc:1}"
        fi 
        ((sc++))
    done
    echo 
}

case $1 in 
    -t) table ;;
    *) main "$@" ;;  
esac
