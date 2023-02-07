git_hooks:
	chmod +x hooks/pre-commit.sh
	chmod +x hooks/pre-push.sh
	rm -f .git/hooks/pre-commit
	rm -f .git/hooks/pre-push
	ln -s -f ../../hooks/pre-commit.sh .git/hooks/pre-commit
	ln -s -f ../../hooks/pre-push.sh .git/hooks/pre-push
