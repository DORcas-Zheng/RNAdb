params.input_path="public2/users/fuyuhua/04Projects/qmzheng/05test/data/*"
params.script_dir="//public2/users/fuyuhua/04Projects/qmzheng/04script/RNAdb/scripts"
params.output_path="/public2/users/fuyuhua/04Projects/qmzheng/05test/output"

params.index ="/public2/users/fuyuhua/04Projects/qmzheng/00ref/Genome/Sus_Genome"
params.fai ="/public2/users/fuyuhua/04Projects/qmzheng/00ref/Genome/Sus_scrofa.Sscrofa11.1.dna_sm.toplevel.fa.fai"
params.ref ="/public2/users/fuyuhua/04Projects/qmzheng/00ref/Genome/Sus_scrofa.Sscrofa11.1.dna_sm.toplevel.fa"
params.gtf ="//public2/users/fuyuhua/04Projects/qmzheng/00ref/Annotation/Sus.gtf"
params.bed="/public2/users/fuyuhua/04Projects/qmzheng/00ref/Annotation/Sus.bed"

QC="$params.script_dir/QC.py"
mapping="$params.script_dir/mapping.py"
calling="$params.script_dir/calling.py"
quantify="$params.script_dir/quantify.py"


Channel
    .fromPath( params.input_path, type: 'dir' )
    .ifEmpty { error "Cannot find any folder matching: ${params.input_path}" }
    .set { input_sample }

process QC {
    tag "$sample.baseName"
    maxForks 1
    errorStrategy 'ignore'
    publishDir "$params.output_path", mode: 'copy'
    input:
    file sample from input_sample

    output:
    file("./QC/${sample.baseName}") into clean_file

    script:       
    """
    python $QC -r ${sample}
    """
}


process mapping {
    tag "$sample.baseName"
    maxForks 1
    errorStrategy 'ignore'
    publishDir "$params.output_path", mode: 'copy'
    input:
    file sample from clean_file

    output:
    file("./mapping/${sample.baseName}") into bam_file,bam_file1

    script:       
    """
    python $mapping -r ${sample} -i $params.index
    """
}


process quantify {
    tag "$sample.baseName"
    maxForks 1
    publishDir "$params.output_path", mode: 'move'
    errorStrategy 'ignore'
    input:
    file sample from bam_file

    output:
    file("./quantify/${sample.baseName}") into diff

    script:
    """
    python $quantify -i ${sample} -g $params.gtf -b $params.bed
    """
}

process calling {
    tag "$sample.baseName"
    maxForks 1
    publishDir "$params.output_path", mode: 'move'
    errorStrategy 'ignore'
    input:
    file sample from bam_file1

    output:
    file("./calling/${sample.baseName}") into joint

    script:
    """
    python $calling -i ${sample} -r $params.ref
    """
}
