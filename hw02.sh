#!/bin/bash

success=0
failure=1

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
    while [[ $# -gt 0 ]]; do
    argument=$1

    case $argument in
        -h)
            print_help
            exit $success
        ;;
        
        -a)
            pdf_flag=true
        ;;

        -b)
            number_flag=true
        ;;

        -c)
            sentence_flag=true
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
    
}

# int main(void)
process_arguments "$@"

if [[ $pdf_flag == true ]]; then
    echo "pdf flag is true"
fi

exit $success