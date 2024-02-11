#!/usr/bin/env python3

import os
import sys
import argparse	
import iterm2

global args

async def main(connection):
	print (args.profile)
	app = await iterm2.async_get_app(connection)
	window = app.current_window
	if window is not None:
		await window.async_create_tab(profile=args.profile,command=args.command + ' ' + args.server)
	else:
		print("No current window")

parser = argparse.ArgumentParser()
parser.add_argument('server', type=str)
parser.add_argument('-p', '--profile', default='tmux', type=str, help='Optional iterm2 profile name')
parser.add_argument('-c', '--command', default='', type=str, help='Optional command to run after starting profile')
args = parser.parse_args()

if len(sys.argv) > 0:
	iterm2.run_until_complete(main)