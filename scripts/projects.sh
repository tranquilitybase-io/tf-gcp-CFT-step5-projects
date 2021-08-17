echo "starting script!!"

PROJECTS_FOLDER=./projects
[ -d $PROJECTS_FOLDER ] && { echo "Removing past deployment file $PROJECTS_FOLDER"; rm -rf $PROJECTS_FOLDER; } || echo "No past deployments found"

ENV_VARIABLES=./env-variables.sh
[ -f $ENV_VARIABLES ] && { echo Sourcing required variables; source $ENV_VARIABLES; } || echo "Can't find $ENV_VARIABLES file"


echo Creating projects folder
mkdir projects
cd ./projects

echo Cloning CFT
CFT_FOLDER=./terraform-example-foundation
[ -d $CFT_FOLDER ] && { echo "Removing past deployment file: $CFT_FOLDER"; rm -rf $CFT_FOLDER; } || echo "No past deployments found"
git clone https://github.com/terraform-google-modules/terraform-example-foundation.git

echo Checkout latest release
cd ./terraform-example-foundation/
git checkout ed164ba
cd ..

echo Cloning gcp projects GSR
GCP_PROJECTS_FOLDER=./gcp-projects
[ -d $GCP_PROJECTS_FOLDER ] && { echo "Removing past deployment file: $GCP_PROJECTS_FOLDER"; rm -rf $GCP_PROJECTS_FOLDER; } || echo "No past deployments found"
gcloud source repos clone gcp-projects --project=$CLOUD_BUILD_PROJECT_ID
cd gcp-projects


echo Checking out plan
git checkout -b plan

echo Copying needed build files
cp -R ../terraform-example-foundation/4-projects/. .
cp ../terraform-example-foundation/build/cloudbuild-tf-* .
cp ../terraform-example-foundation/build/tf-wrapper.sh .
chmod 755 ./tf-wrapper.sh


echo Removing unneeded access_context.auto.example.tfvars
TF_EXAMPLE_VARS=./access_context.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found";  }

echo Copying in needed access_context.auto.tfvars
TF_VARS=../../access_context.auto.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }


echo Removing unneeded common.auto.examples.tfvars
TF_EXAMPLE_VARS=./common.auto.examples.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found";  }

echo Copying in needed common.auto.tfvars
TF_VARS=../../common.auto.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }


echo Removing unneeded development.auto.example.tfvars
TF_EXAMPLE_VARS=./development.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found"; }

echo Copying in needed development.auto.tfvars
TF_VARS=../../development.auto.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }


echo Removing unneeded non-production.auto.example.tfvars
TF_EXAMPLE_VARS=./non-production.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found"; }

echo Copying in needed non-production.auto.tfvars
TF_VARS=../../non-production.auto.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }


echo Removing unneeded production.auto.example.tfvars
TF_EXAMPLE_VARS=./production.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found";  }

echo Copying in needed production.auto.tfvars
TF_VARS=../../production.auto.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }


echo Removing unneeded shared.auto.example.tfvars
TF_EXAMPLE_VARS=./shared.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found"; }

echo Copying in needed shared.auto.tfvars
TF_VARS=../../shared.auto.tfvars
COPY_LOCATION=.
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }


echo Removing unneeded backend example file
TF_EXAMPLE_VARS=./business_unit_1/shared/backend.tf
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found";  }

echo Copying in needed backend example file
TF_VARS=../../backend.tf #TODO need to edit this
COPY_LOCATION=./business_unit_2/shared/
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }


echo Local BU1 shared file TF apply
cd ./business_unit_1/shared/
terraform init
terraform plan
terraform apply
bu1_app_infra_pipeline_cloudbuild_sa=$(terraform output cloudbuild_sa)
cd ../..


echo Removing unneeded backend example file
TF_EXAMPLE_VARS=./business_unit_2/shared/backend.tf
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found";  }

echo Copying in needed backend example file
TF_VARS=../../backend.tf #TODO need to edit this
COPY_LOCATION=./business_unit_2/shared/
[ -f $TF_VARS ] && { echo "Copying $TF_VARS to $COPY_LOCATION"; cp $TF_VARS $COPY_LOCATION; } || { echo "No $TF_VARS file found"; exit 1; }

echo Local BU1 shared file TF apply
cd ./business_unit_2/shared/
terraform init
terraform plan
terraform apply
bu2_app_infra_pipeline_cloudbuild_sa=$(terraform output cloudbuild_sa)
cd ../..


echo Removing unneeded business_unit_1.auto.example.tfvars variables
TF_EXAMPLE_VARS=./business_unit_1.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found"; exit 1; }

echo Writing in needed business_unit_1.auto.tfvars
echo "app_infra_pipeline_cloudbuild_sa = \"$bu1_app_infra_pipeline_cloudbuild_sa\"" > business_unit_1.auto.tfvars

echo Removing unneeded business_unit_2.auto.example.tfvars variables
TF_EXAMPLE_VARS=./business_unit_2.auto.example.tfvars
[ -f $TF_EXAMPLE_VARS ] && { echo "Removing unneeded $TF_EXAMPLE_VARS file: $TF_EXAMPLE_VARS"; rm $TF_EXAMPLE_VARS; } || { echo "No $TF_EXAMPLE_VARS file found"; exit 1; }

echo Writing in needed business_unit_2.auto.tfvars variables
echo "app_infra_pipeline_cloudbuild_sa = \"$bu2_app_infra_pipeline_cloudbuild_sa\"" > business_unit_2.auto.tfvars


echo pushing plan
git add .
git commit -m 'Your message'
git push --set-upstream origin plan

sleep 300

git checkout -b production
git push origin production

sleep 300
git checkout -b development
git push origin development

sleep 300

git checkout -b non-production
git push origin non-production