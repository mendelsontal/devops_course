echo -e '#!/usr/bin/env bash\necho Haifa' > ~/city.sh
chmod +x ~/city.sh
./city.sh
cat ./city.sh

echo -e '#!/usr/bin/env ksh\necho Haifa' > ~/city.sh
chmod +x ~/city.sh
./city.sh
cat ./city.sh

echo -e '#!/usr/bin/env bash\nvar1="pickle"\nvar2="rick"\necho "$var1 $var2"' > ~/rick.sh
chmod +x ~/rick.sh
./rick.sh

source rick.sh
. ./rick.sh

echo -e '#!/usr/bin/env bash\n# Part of chapter 23 testing - variables\n\n# Set variables\nvar1="pickle"\nvar2="rick"\n\n# Output of both values\necho "$var1 $var2"' > ~/rick.sh
chmod +x ~/rick.sh
cat ./rick.sh