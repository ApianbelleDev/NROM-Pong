Windows:
	asm6.exe main.asm Pong.nes
	#if fceux is added to path and you want it to automatically open, uncomment the next line
	#fceux Pong.nes
Linux:
	asm6 main.asm Pong.nes
	#if you want fceux to automatically open, uncomment the next line
	fceux Pong.nes 	
