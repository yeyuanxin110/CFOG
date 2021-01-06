function Wenvifile1(PTs,Path)
	fp = fopen(Path, 'w');
	fprintf(fp,'%s\n','; ENVI Image to Image GCP File');
	fprintf(fp,'%s\n','; base file: C:\Documents and Settings\All Users\Documents\My Pictures\Ê¾ÀýÍ¼Æ¬\test1ref.bmp');
	fprintf(fp,'%s\n','; warp file: C:\Documents and Settings\All Users\Documents\My Pictures\Ê¾ÀýÍ¼Æ¬\test1sen.bmp');
	fprintf(fp,'%s\n','; Base Image (x,y), Warp Image (x,y)');
	fprintf(fp,'%s\n',';');
    
    fprintf(fp,'%10.2f%10.2f%10.2f%10.2f\n',PTs);
    fclose(fp);