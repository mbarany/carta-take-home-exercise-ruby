# Carta take home assessment
This solution was implemented using Ruby 3.1

## Run the program
If you have Ruby installed you can just run it like this:
```bash
./vesting_program example1.csv 2020-04-01
./vesting_program example2.csv 2021-01-01
./vesting_program example3.csv 2021-01-01 1
```

Otherwise you can use docker to run it like this:
```bash
docker run --rm -it -v ${PWD}:/app --workdir /app ruby:3.1 bash

./vesting_program example1.csv 2020-03-03
./vesting_program example2.csv 2021-01-01
./vesting_program example3.csv 2021-01-01 1
```

## Assumptions
The program will be provided a mostly valid CSV file in that it has the correct number of commas for each row. If I had to lint the CSV file I would just use the [csvlint gem](https://github.com/Data-Liberation-Front/csvlint.rb). The award id is assumed to be unique and I am not checking if two employees have the same award id. Employee IDs are not checked against employee names for uniqueness.

License
=======
Copyright 2023 Michael Barany

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
