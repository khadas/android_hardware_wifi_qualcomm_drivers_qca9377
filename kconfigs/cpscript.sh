#! /bin/sh
##############################################
#$1 should be kernel source code dir         #
#$2 should be command(copy or recover)       #
#use md5 to check the source config is the same#
#with target or not, in case that twice copy #
#cover the target config's backup              #
##############################################
kernel_dir=$1
command=$2







source_config=${kernel_dir}/../hardware/wifi/qualcomm/drivers/qca9377/kconfigs/Kconfig
config_backup=${kernel_dir}/../hardware/wifi/qualcomm/drivers/qca9377/kconfigs/Kconfig.bak
target_config=${kernel_dir}/net/wireless/Kconfig

if test ! -e $source_config -o ! -e $target_config 
then
echo "ERROR!!! kernel_dir is not correct! exit" 
echo "usage:\r\ncpscript.sh \"kernel source code dir\"  copy/recover"
exit
fi

if [ ! "$command" = "copy" -a ! "$command" = "recover" ]; then
echo "ERROR!!! there is no command!" 
echo "usage:\r\ncpscript.sh \"kernel source code dir\"  copy/recover"
exit
fi



if [ "$command" = "copy" ];then

echo "copy qca9377 configuration to kernel"
  t_md5=`md5sum ${target_config}`
  s_md5=`md5sum ${source_config}`
  t_md5=${t_md5%%" "*}
  s_md5=${s_md5%%" "*}
  echo "target_config's md5 is ${t_md5}"
  echo "source_config's md5 is ${s_md5}"
  
  if [ "$t_md5" = "$s_md5" ];then
	echo "config copy already done before, exit"
	exit
  fi
  
  cp  ${target_config} ${config_backup}
  cp -rf ${source_config} ${target_config}

elif [ "$command" = "recover" ];then

echo "recover Kconfig"
	cp ${config_backup} ${target_config}
#	rm -f ${target_config}.back
fi


