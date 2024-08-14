#!/bin/bash
if [ $# -eq 0 ]
then
        echo "No parameters"
        exit
fi
name=$1
if [ -n "$2" ]
then
        server=$2
else
        server=$(cat /etc/resolv.conf | grep nameserver | cut -d" " -f 2)
fi

get_list_record (){
        fname=$1
        if [ -n "$2" ]
        then
                ftype=$2
        else
                ftype="A"
        fi
        if [ "$ftype" = "PTR" ]; then
                result=$(dig +short @$server -x $fname | cut -d" " -f 2)
        else
                result=$(dig +short @$server $fname $ftype | cut -d" " -f 2)
        fi
        echo $result
}

echo -e "\nChecking domain: $name"
echo -e "The DNS server used is: $server\n"
echo "Resolved DNS names in:"
ip_list=$(get_list_record $name)

if [ ${#ip_list} = 0 ]
then
        echo -e "\tDomain name $name not resolved"
        exit
fi

for ip in $ip_list
do
        echo -e "\t$ip"
done


echo "Looking for MX records"
str_mx=$(get_list_record $name "MX")

if [ ${#str_mx} = 0 ]
then
        echo -e "\tMX records for domain $name not found"
        exit
fi

for mx in $str_mx
do
        echo -e "\t$mx"
        mx_ip_list=$(get_list_record $mx)
        if [ ${#mx_ip_list} = 0 ]
        then
                echo -e "\t\tDNS record for MX record $mx not found"
        else
                for ip_mx in $mx_ip_list
                do
                        echo -e "\t\t$ip_mx\c"
                        ptr_rec=$(get_list_record $ip_mx "PTR")
                        if [ ${#ptr_rec} = 0 ] ; then
                                echo -e " ... check PTR record ...PTR record not found"
                        else
                                if [ "$mx" = "$ptr_rec" ]; then
                                        echo -e " ... check PTR record ... OK"
                                else
                                        echo -e " ... check PTR record ... FAIL ($ptr_rec)"
                                fi
                        fi
                done
        fi
done
