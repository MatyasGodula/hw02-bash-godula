#!/bin/bash

success=0
failure=1

activated_flag=false

pdf_flag=false
number_flag=false
sentence_flag=false

print_help() {
    echo -e "run with these arguments:\n"\
            "-h to print help\n"\
            "-a to list all pdfs in the current directory\n"\
            "-b to echo all lines staring with a number from stdin\n"\
            "-c to read input from stdin and write each sentence on a new line, separated by '.' or '?' etc."
}

process_arguments() {
    if [[ $# -eq 0 ]]; then
        print_help
        exit $failure
    fi

    while [[ $# -gt 0 ]]; do
    argument=$1

    case $argument in
        -h)
            print_help
            exit $success
        ;;
        
        -a)
            if [[ $activated_flag == false ]]; then
                pdf_flag=true
                activated_flag=true
            fi
        ;;

        -b)
            if [[ $activated_flag == false ]]; then
                number_flag=true
                activated_flag=true
            fi
        ;;

        -c)
            if [[ $activated_flag == false ]]; then
                sentence_flag=true
                activated_flag=true
            fi
        ;;
        *)
            print_help
            exit $failure
        ;;
    esac

    shift
done
}

pdf_listing() {
    # diables case sensitivity
    shopt -s nocaseglob
    for file in *.pdf .*.pdf; do
        if [ -e "$file" ]; then
            pdf_files+=("$file")
        fi
    done
    # enables it back
    shopt -u nocaseglob
}

stdin_read() {
    while read -r line; do
        if [[ $line =~ ^[0-9]+ ]]; then
            echo "$line" | sed -n 's/^[0-9]\+//p'
        elif [[ $line =~ ^[+-][0-9]+ ]]; then
            echo "$line" | sed -n 's/^[+-][0-9]\+//p'
        fi
    done
}

sentences_process() {
    # reads the input and stores it in text, plus replaces all \n with spaces
    text=$(tr '\n' ' ')
    # macthes the criteria for the regex
    # exaplanation: starts with an uppercase letter, followed by any number of characters that aren .?! and ends with one of them
    echo "$text" | grep -o -E '[[:upper:]][^.!?]*[.!?]'
}

# int main(void)
process_arguments "$@"

if [[ $pdf_flag == true ]]; then
    pdf_files=()
    pdf_listing
    printf "%s\n" "${pdf_files[@]}"
fi

if [[ $number_flag == true ]]; then
    stdin_read
fi

if [[ $sentence_flag == true ]]; then
    sentences_process
fi

exit $success