
ls -la
pwd
env

if [ $TERRATEST == true ]; then
  echo "run test"
else
  echo "skipping test"
fi



echo "Run terraform deployment if test have passed"
