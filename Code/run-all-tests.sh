#!/bin/bash

mkdir -p outputs

for scoring in 'neg_mean_absolute_error' 'neg_mean_squared_error' 'explained_variance' 'r2'; do
	for type in 'RANGE' 'JOIN'; do
		for attr in 'o_orderkey' 'o_totalprice' 'l_orderkey' 'l_extendedprice'; do
			for outvar in 'Avg_Execution_Time' 'Result_Set_Returned'; do
				for dist in 'Zipf' 'Uniform' 'All'; do
					echo "Running experiment for predictions of ${outvar} of ${type} queries with range constraint on ${attr} (distribution: ${dist}) and ${scoring} cost function..."
					/usr/bin/time -o outputs/r.time-${type}-${attr}-${outvar}-${dist}-${scoring} \
						python3 regression.py -D ${dist} -t ${type} -i ${attr} -o ${outvar} -s ${scoring}\
						2>>outputs/r.err-${type}-${attr}-${outvar}-${dist}-${scoring} | \
						tee -a outputs/r.out-${type}-${attr}-${outvar}-${dist}-${scoring};
				done
			done
		done
	done
done
