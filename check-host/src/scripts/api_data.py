import json
import requests


def id_key_part(target, method):
	id_key_req = json.loads(requests.get(f"https://check-host.net/check-{method}?host={target}&node=ir3.node.check-host.net&node=ir4.node.check-host.net&node=ir1.node.check-host.net", headers={"Accept": "application/json"}).text)
	# trigger // reached API limit
	if "request_id" not in id_key_req:
		return 0
	return id_key_req


def result_data_part(id_key):
	result_data_req = json.loads(requests.get(f"https://check-host.net/check-result/" + id_key["request_id"]).text)
	return result_data_req