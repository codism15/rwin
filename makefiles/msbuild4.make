BUILDER=C:/WINDOWS/Microsoft.NET/Framework/v4.0.30319/msbuild.exe

SOLUTION=$(wildcard *.sln)

all:
	${BUILDER} /nologo \
		/p:Configuration=Release \
		/p:WarningLevel=0 \
		/verbosity:quiet \
		${SOLUTION}
