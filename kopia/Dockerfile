FROM kopia/kopia

ARG HOSTNAME
ARG KOPIA_GCS_BUCKET=mafro-homelab-backup

COPY mafro-backup-7deca97f9b3e.json /mafro-backup-7deca97f9b3e.json

RUN --mount=type=secret,id=KOPIA_PASSWORD,env=KOPIA_PASSWORD \
	kopia repository connect gcs \
		--credentials-file=/mafro-backup-7deca97f9b3e.json \
		--bucket=${KOPIA_GCS_BUCKET} \
		--override-hostname=${HOSTNAME}

ENTRYPOINT ["kopia"]
