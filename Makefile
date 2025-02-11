# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

all: push push-mongodb-install

TAG = 0.1
# PREFIX = staging-k8s.gcr.io/peer-finder
PREFIX = tclh123/peer-finder

server: peer-finder.go
	CGO_ENABLED=0 go build -a -installsuffix cgo --ldflags '-w' ./peer-finder.go

release: server
	gsutil cp peer-finder gs://kubernetes-release/pets/peer-finder

container: server
	docker build --pull -t $(PREFIX):$(TAG) .

push: container build-mongodb-install
	# gcloud docker -- push $(PREFIX):$(TAG)
	docker push $(PREFIX):$(TAG)

clean:
	rm -f peer-finder

build-mongodb-install: server
	docker build -t tclh123/mongodb-install:0.7 -f Dockerfile-mongodb-install .

push-mongodb-install: build-mongodb-install
	docker push tclh123/mongodb-install:0.7
