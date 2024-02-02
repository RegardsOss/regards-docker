#!/bin/bash -e

services=$(docker service ls --format '{{ '{{' }} .ID {{ '}}' }}' \
  | xargs docker service ps --format '{{ '{{' }} .ID {{ '}}' }}\t{{ '{{' }} .DesiredState {{ '}}' }}\t{{ '{{' }} .Name {{ '}}' }}\t{{ '{{' }} .Node {{ '}}' }}' \
  | grep -E 'Running|Starting' \
  | awk -F'\t' '{split($3, array, ".");printf("%s\t%s\t%s\n",$1,array[1],$4);}' \
  | awk -F'\t' '{printf("%s\t%s\t%s\t",$1,$2,$3); system("docker service inspect --format \"{{ '{{' }}if .Spec.TaskTemplate.Resources.Reservations{{ '}}' }}{{ '{{' }}.Spec.TaskTemplate.Resources.Reservations.MemoryBytes{{ '}}' }}\t{{ '{{' }} .Spec.TaskTemplate.Resources.Reservations.NanoCPUs {{ '}}' }}{{ '{{' }}else{{ '}}' }}0\t0{{ '{{' }}end{{ '}}' }},{{ '{{' }}if .Spec.TaskTemplate.Resources.Limits{{ '}}' }}{{ '{{' }}.Spec.TaskTemplate.Resources.Limits.MemoryBytes{{ '}}' }}\t{{ '{{' }} .Spec.TaskTemplate.Resources.Limits.NanoCPUs {{ '}}' }}{{ '{{' }}else{{ '}}' }}0\t0{{ '{{' }}end{{ '}}' }}\" " $2); printf("//////////")}' \
  | sed 's/\/\/\/\/\/\/\/\/\/\//\n/g' \
  | grep -v '^$' \
  | sed 's/\t/,/g')
nbServices=$(printf "%s" "$services" | grep -c "^")
excelLineServiceStart=11
excelLineServiceEnd=$(expr $excelLineServiceStart + $nbServices)
excelLineFirstServer=$(expr $excelLineServiceEnd + 2)
excelLineFirstFormula==$(expr $excelLineServiceStart + 1)

printf >&2 ",,Tuto Excel\n"
printf >&2 ",,1. Copy the content inside Excel (select column A1 then paste)\n"
printf >&2 ",,2. Go to Data > Convert to column (Data tools)\n"
printf >&2 ",,3. Separator : comma and not space\n"
printf >&2 ",,4. Apply\n"
printf >&2 ",,6. Select H$excelLineServiceStart to K$excelLineServiceStart formula\n"
printf >&2 ",,8. Apply these formula into H$excelLineServiceEnd ... K$excelLineServiceEnd\n"
printf >&2 "\n\n"
printf >&2 "ContainerID,Service Name,Server,memory reserved bytes,nanoCPU reserved,memory limit bytes,nanoCPU limit,Memory reserved Gb,CPU reserved,Memory limit Gb,CPU limit\n"
printf >&2 ",,,,,,,=D$excelLineServiceStart/10^9,=E$excelLineServiceStart/10^9,=F$excelLineServiceStart/10^9,=G$excelLineServiceStart/10^9\n"
printf >&2 "$services\n"
printf >&2 ",,Server name,Memory available Mb,CPU available,Total memory reserved Gb,%% Memory reserved,Total memory limit Gb,%% Memory limit,Total reserved CPU,%% CPU reserved,Total limit CPU,%% CPU limit\n"
{%   for hostname in groups['all'] %}
{%     if hostname == groups['master'][0] %}
    cpu=$(cat /proc/cpuinfo | grep -v '^\w' | wc -l)
    ram=$(free -m | grep Mem: | awk '{print $2}')
{%     else %}
    cpu=$(ssh {{ hostvars[hostname]['ansible_host'] }} "cat /proc/cpuinfo | grep -v '^\w' | wc -l")
    ram=$(ssh {{ hostvars[hostname]['ansible_host'] }} "free -m | grep Mem: | awk '{print \$2}'")
{%     endif %}
    excelLineCurrentServer=$(expr $excelLineFirstServer + {{ loop.index0 }})

    printf >&2 ",,{{ hostvars[hostname]['ansible_host'] }},$ram,$cpu,=SOMME.SI.ENS(H\$$excelLineServiceStart:H\$$excelLineServiceEnd;C\$$excelLineServiceStart:C\$$excelLineServiceEnd;C$excelLineCurrentServer),=100*F$excelLineCurrentServer*1000/D$excelLineCurrentServer,=SOMME.SI.ENS(J\$$excelLineServiceStart:J\$$excelLineServiceEnd;C\$$excelLineServiceStart:C\$$excelLineServiceEnd;C$excelLineCurrentServer),=100*H$excelLineCurrentServer*1000/D$excelLineCurrentServer,=SOMME.SI.ENS(I\$$excelLineServiceStart:I\$$excelLineServiceEnd;C\$$excelLineServiceStart:C\$$excelLineServiceEnd;C$excelLineCurrentServer),=100*J$excelLineCurrentServer/E$excelLineCurrentServer,=SOMME.SI.ENS(K\$$excelLineServiceStart:K\$$excelLineServiceEnd;C\$$excelLineServiceStart:C\$$excelLineServiceEnd;C$excelLineCurrentServer),=100*L$excelLineCurrentServer/E$excelLineCurrentServer\n"
{%   endfor %}
