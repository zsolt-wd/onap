    1  help
    2  gcloud help
    3  gcloud app
    4  gcloud --version
    5  kubectl get svc
    6  gcloud container clusters create bootcamp --num-nodes 5 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"
    7  gcloud config set compute/zone europe-west3-b
    8  gcloud container clusters create bootcamp --num-nodes 5 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"
    9  kubectl run nginx --image=nginx:1.10.0
   10  kubectl get pods
   11  kubectl get deployments
   12  kubectl delete deployment nginx
   13  kubectl get deployments
   14  kubectl get pods
   15  gcloud container clusters delete bootcamp 
   16  gcloud container clusters get-credentials cluster-1 --zone europe-west1-b --project onap-proto
   17  kubectl get nodes
   18  git 
   19  git clone https://gerrit.onap.org/r/p/oom.git
   20  cd oom/
   21  ./createConfig.sh -n onapTrial
   22  ls -la
   23  ls -la kubernetes/
   24  cd kubernetes/oneclick/
   25  ls -la
   26  ./createConfig.sh -n onapTrial
   27  ./createAll.bash -n onapTrial
   28  ./createAll.bash -n onap
   29  curl -o  helm-v2.8.1-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.8.1-linux-amd64.tar.gz
   30  ls -lrt
   31  gunzip helm-v2.8.1-linux-amd64.tar.gz
   32  ls
   33  tar -tvf helm-v2.8.1-linux-amd64.tar 
   34  mkdir helm
   35  mv helm-v2.8.1-linux-amd64.tar helm
   36  cd helm/
   37  tar xvf helm-v2.8.1-linux-amd64.tar 
   38  ls
   39  cd linux-amd64/
   40  ls
   41  ls -lrt
   42  file helm
   43  xxxexport PATH=$PATH
   44  echo $PATH
   45  echo /oom/kubernetes/oneclick/helm/linux-amd64
   46  echo ~/oom/kubernetes/oneclick/helm/linux-amd64
   47  export PATH=$PATH:/home/zsolt_kecskes/oom/kubernetes/oneclick/helm/linux-amd64
   48  helm --version
   49  helm -version
   50  helm -v
   51  history 
   52  cd
   53  cd kubernetes/oneclick/
   54  ls
   55  cd oom/
   56  ls
   57  cd kubernetes/oneclick/
   58  ./createAll.bash -n onap
   59  cubectl get ns
   60  kubectl get ns
   61  kubectl delete ns onap-consul
   62  ./createAll.bash -n onap
   63  kubectl get ns
   64  ./createAll.bash -n onap
   65  ./createAll.bash -n onap1
   66  helm init
   67  ./createAll.bash -n onap2
   68  kubectl config view
   69  kubectl get pods --namespace kube-system
   70  kubectl get pods
   71  kubectl get pod
   72  cd
   73  ls -la
   74  cd oom/
   75  ls
   76  cd ..
   77  mv ~/oom/kubernetes/oneclick/ ~
   78  ls -l
   79  mv oneclick/ oom/kubernetes/
   80  mv ~/oom/kubernetes/oneclick/helm/ ~
   81  ls
   82  echo $PATH
   83  xxxxexport PATH=/home/zsolt_kecskes/gopath/bin:/google/gopath/bin:/google/google-cloud-sdk/bin:/usr/local/go/bin:/opt/gradle/bin:/opt/maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin::/google/go_appengine:/google/google_appengine:/home/zsolt_kecskes/helm/
   84  pwd
   85  ls helm/
   86  cd helm/linux-amd64/
   87  mv helm LICENSE README.md ..
   88  ls -la
   89  cd ..
   90  rmdir linux-amd64/
   91  ls
   92  pwd
   93  export PATH=/home/zsolt_kecskes/gopath/bin:/google/gopath/bin:/google/google-cloud-sdk/bin:/usr/local/go/bin:/opt/gradle/bin:/opt/maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin::/google/go_appengine:/google/google_appengine:/home/zsolt_kecskes/helm
   94  cd
   95  cd oom/kubernetes/oneclick/tools/
   96  ls
   97  cd ..
   98  ls
   99  ls -la
  100  ./createAll.bash -n onap2
  101  ./createAll.bash -n onap3
  102  kubectl describe ns onap3
  103  helm delete --purge onap-config
  104  kubectl get deployments
  105  kubectl -n kube-system delete deployment tiller-deploy
  106  kubectl get deployment
  107  kubectl -n kube-system get deployment
  108  kubectl -n kube-system get accounts
  109  kubectl -n kube-system get account
  110  kubectl -n kube-system delete serviceaccount tiller
  111  kubectl -n kube-system delete ClusterRoleBinding tiller-clusterrolebinding
  112  cat > tiller-serviceaccount.yaml << EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: tiller-clusterrolebinding
subjects:
- kind: ServiceAccount
  name: tiller
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: ""
EOF

  113  cat tiller-serviceaccount.yaml << EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: tiller-clusterrolebinding
subjects:
- kind: ServiceAccount
  name: tiller
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: ""
EOF

  114  reset
  115  cat tiller-serviceaccount.yaml
  116  kubectl create -f tiller-serviceaccount.yaml
  117  helm init --service-account tiller --upgrade
  118  pwd
  119  ls
  120  ./createAll.bash -n onap4
  121  kubectl svcs
  122  kubectl svc
  123  kubectl get svc
  124  kubectl -n kube-system get svc
  125  ls
  126  ls ./tools/
  127  chmod +x  ./tools/autoCleanConfig.bash 
  128  chmod +x  ./tools/autoCreateConfig.bash 
  129  chmod +x  ./tools/collectInfo.bash 
  130  ./tools/autoCleanConfig.bash onap
  131  ./tools/autoCleanConfig.bash onap1
  132  ./tools/autoCleanConfig.bash onap2
  133  ./tools/autoCleanConfig.bash onap3
  134  ./tools/autoCleanConfig.bash onap-consul
  135  ./tools/autoCleanConfig.bash onap1-consul
  136  ./tools/autoCleanConfig.bash onap2-consul
  137  ./tools/autoCleanConfig.bash onap3-consul
  138  history 
  139  /createAll.bash -n onap5
  140  createAll.bash -n onap5
  141  history 
  142  ./tools/collectInfo.bash 
  143  ./tools/collectInfo.bash cat /var/log/ona
  144  ./tools/collectInfo.bash cat /var/log/onap
  145  cat /var/log/onap
  146  uname -a
  147  cd ~
  148  cat tiller-serviceaccount.yaml << EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: tiller-clusterrolebinding
subjects:
- kind: ServiceAccount
  name: tiller
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: ter-admin
  apiGroup: ""
EOF

  149  ls -la
  150  kubectl get nodes
  151  history 
  152  ls typescript 
  153  ls -l typescript 
  154  git remote add origin https://github.com/zsolt-wd/onap.git
  155  mkdir git
  156  cd git
  157  git add .
  158  git 
  159  git init .
  160  ls
  161  cp ../typescript 
  162  cp ../typescript  .
  163  history > bsh_history
