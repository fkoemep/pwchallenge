# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

from __future__ import annotations

import datetime
import json

import pendulum

from airflow.decorators import dag, task
from airflow.models import Variable

from tasks.extract_alternative import extract
from tasks.transform_alternative import transform
from tasks.load_alternative import load


@dag(
    schedule=None,
    catchup=False,
    tags=["prod"],
)
def medical_data_process_alternative():
    medical_data = extract()
    medical_data_transformed = transform(medical_data)
    load(medical_data_transformed)


medical_data_process_alternative()
